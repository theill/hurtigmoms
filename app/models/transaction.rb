class Transaction < ActiveRecord::Base
  TRANSACTION_TYPES = { :buy => 1, :sell => 2, :pay => 3 }
  
  belongs_to :fiscal_year
  belongs_to :customer
  has_many :annexes, :dependent => :destroy
  has_many :related_transactions, :through => :equalizations
  has_many :equalizations

  validates_presence_of :fiscal_year_id, :amount

  before_validation_on_create :set_attachment_no
  before_save :set_customer
  
  named_scope :incomplete, :conditions => 'amount IS NULL OR created_at IS NULL OR currency IS NULL'
  named_scope :wrong_fiscal_year, :conditions => 'DATE(transactions.created_at) > fiscal_years.end_date or DATE(transactions.created_at) < fiscal_years.start_date', :joins => :fiscal_year, :order => 'created_at DESC'
  named_scope :without_related_transactions, :conditions => 'transactions.transaction_type = 3 and transactions.id NOT IN (select related_transaction_id FROM equalizations)', :order => 'created_at DESC'
  # select t.*
  # from transactions t
  # where t.transaction_type = 3
  # and t.fiscal_year_id = 7
  # and t.id not in (
  #   select related_transaction_id
  #   from equalizations
  # )
  
  
  HUMANIZED_ATTRIBUTES = {
    :amount => I18n.t(:amount, :scope => :transaction)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def self.search(search, page)
    transactions = paginate(:per_page => 20, :page => page, :conditions => ['LOWER(transactions.note) LIKE ? OR LOWER(customers.name) LIKE ?', "%#{(search || '').downcase}%", "%#{(search || '').downcase}%"], :include => [:customer, :annexes, :related_transactions], :order => 'transactions.created_at DESC')
    related_transactions = transactions.map { |t| t.related_transactions.map { |t2| t2.id } }.flatten
    transactions.delete_if { |t| related_transactions.include?(t.id) }
    
    # transactions = Transaction.find(:all, :conditions => ['LOWER(transactions.note) LIKE ? OR LOWER(customers.name) LIKE ?', "%#{(search || '').downcase}%", "%#{(search || '').downcase}%"], :include => [:customer, :annexes, :related_transactions], :order => 'transactions.created_at DESC')
    # related_transactions = transactions.map { |t| t.related_transactions.map { |t2| t2.id } }.flatten
    # transactions = transactions.delete_if { |t| related_transactions.include?(t.id) }
    # 
    # transactions.paginate(:per_page => 20, :page => page)
  end

  attr_accessor :customer_name

  def customer_name
    @customer_name || (self.customer.name if self.customer)
  end
  
  def incomplete?
    amount.nil? || created_at.nil? || currency.nil?
  end
  
  def set_attachment_no
    self.attachment_no = (self.fiscal_year.transactions.maximum(:attachment_no) || 0) + 1 if self.attachment_no == 0
  end

  def set_customer
    self.customer = self.fiscal_year.user.customers.find_or_create_by_name(self.customer_name) unless self.customer_name.blank?
  end
  
  def build_attachments(attachments)
    attachments.each do |attachment|
      self.annexes.build(:attachment => attachment)
    end
  end
end