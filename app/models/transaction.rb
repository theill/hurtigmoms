class Transaction < ActiveRecord::Base
  TRANSACTION_TYPES = { :buy => 1, :sell => 2, :pay => 3 }
  
  belongs_to :fiscal_year
  belongs_to :customer
  has_many :annexes, :dependent => :destroy

  validates_presence_of :fiscal_year_id, :amount

  before_validation_on_create :set_attachment_no
  before_save :set_customer
  
  named_scope :incomplete, :conditions => 'amount IS NULL OR amount = 0 OR created_at IS NULL OR currency IS NULL'

  HUMANIZED_ATTRIBUTES = {
    :amount => I18n.t(:amount, :scope => :transaction)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  attr_accessor :customer_name

  def customer_name
    @customer_name || (self.customer.name if self.customer)
  end
  
  def incomplete?
    amount.nil? || amount == 0 || created_at.nil? || currency.nil?
  end
  
  def set_attachment_no
    self.attachment_no = (self.fiscal_year.transactions.maximum(:attachment_no) || 0) + 1 if self.attachment_no == 0
  end

  def set_customer
    self.customer = self.fiscal_year.user.customers.find_or_create_by_name(self.customer_name) unless self.customer_name.blank?
  end
  
  def add_attachments_from_mail(mail)
    mail.attachments.each do |attachment|
      self.annexes.create(:attachment => attachment)
    end
  end
end