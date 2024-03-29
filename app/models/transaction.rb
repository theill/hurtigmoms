# encoding: utf-8

class Transaction < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  
  TRANSACTION_TYPES = { :buy => 1, :sell => 2, :pay => 3 }
  
  belongs_to :fiscal_year
  belongs_to :customer
  has_many :annexes, :dependent => :destroy
  # TODO: replace related_transactions with 'linked_to'
  has_many :related_transactions, :through => :equalizations
  has_many :equalizations, :dependent => :destroy
  
  has_many :relations_to, :foreign_key => 'transaction_id',  :class_name => 'Equalization'
  has_many :relations_from, :foreign_key => 'related_transaction_id', :class_name => 'Equalization'
  has_many :linked_to, :through => :relations_to, :source => :related_transaction
  has_many :linked_from, :through => :relations_from, :source => :transaction

  validates_presence_of :fiscal_year_id, :amount
  validates_presence_of :created_at, :on => :update
  validates_uniqueness_of :attachment_no, :scope => :customer_id, :allow_nil => true

  before_validation :set_attachment_no
  before_save :set_customer
  
  scope :payments, :conditions => ['transaction_type = ?', TRANSACTION_TYPES[:pay]]
  scope :income, :conditions => ['transaction_type = ?', TRANSACTION_TYPES[:sell]]
  scope :expense, :conditions => ['transaction_type = ?', TRANSACTION_TYPES[:buy]]
  scope :incomplete, :conditions => 'amount IS NULL OR created_at IS NULL OR currency IS NULL'
  scope :in_fiscal_year, lambda { |fiscal_year| { :conditions => ['fiscal_year_id = ?', fiscal_year.id] } }
  scope :wrong_fiscal_year, :conditions => 'DATE(transactions.created_at) > fiscal_years.end_date OR DATE(transactions.created_at) < fiscal_years.start_date', :joins => :fiscal_year, :order => 'created_at DESC'
  scope :without_related_transactions, :conditions => ['transactions.transaction_type = ? and transactions.id NOT IN (select related_transaction_id FROM equalizations)', TRANSACTION_TYPES[:pay]], :order => 'created_at DESC'
  scope :between, lambda { |start_date, end_date| { :conditions => ['DATE(transactions.created_at) BETWEEN ? AND ?', start_date, end_date] } }
  scope :filtered, lambda { |query| { :conditions => ['(LOWER(transactions.note) LIKE ?) OR (LOWER(customers.name) LIKE ?) OR (transactions.amount > 0 AND transactions.amount = ?)', "%#{query.downcase}%", "%#{query.downcase}%", query.to_f], :include => :customer } }
  scope :filter_by_type, lambda { |transaction_type| { :conditions => ['transactions.transaction_type = ?', transaction_type] } }
  scope :latest, :order => 'created_at DESC', :limit => 5
  
  HUMANIZED_ATTRIBUTES = {
    :amount => I18n.t(:amount, :scope => :transaction)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def self.per_page
    20
  end
  
  def self.search(page, options)
    transactions = Transaction
    
    if options[:transaction_type] && TRANSACTION_TYPES.values.include?(options[:transaction_type].to_i)
      transactions = transactions.filter_by_type(options[:transaction_type])
    end
    
    if options[:search]
      transactions = transactions.filtered(options[:search])
    end
    
    if options[:start_date] && options[:end_date]
      transactions = transactions.between(options[:start_date], options[:end_date])
    end
    
    transactions = transactions.paginate(:page => page, :include => [:customer, :annexes, :related_transactions, :linked_to, :linked_from], :order => 'transactions.created_at DESC')
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
  
  def amount_in(to_currency)
    ExchangeRate.exchange_to(amount, currency, to_currency)
  end
  
  def amount_formatted
    number_to_currency(self.amount, :unit => '', :format => '%n')
  end
  
  def amount_formatted=(v)
    self.amount = v.gsub(/\./, '').gsub(/,/, '.')
  end
  
  def linked
    self.linked_to | self.linked_from
  end
  
  def relations
    self.relations_to | self.relations_from
  end
  
  def incomplete?
    amount.nil? || created_at.nil? || currency.nil?
  end
  
  def set_attachment_no
    if (self.attachment_no == "0" || self.attachment_no.blank?) && self.fiscal_year.present?
      attachment_no_maximum = (self.fiscal_year.transactions.maximum(:attachment_no) || "00000")[4..-1].to_i # cut out year
      self.attachment_no = "#{self.fiscal_year.start_date.year}#{'%.5d' % (attachment_no_maximum + 1)}"
    end
  end

  # force new attachment no
  def assign_attachment_no!
    self.attachment_no = nil
    self.set_attachment_no
    self.save
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