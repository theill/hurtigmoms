require 'aws/s3'

class Transaction < ActiveRecord::Base
  TRANSACTION_TYPES = { :buy => 1, :sell => 2, :pay => 3 }
  
  belongs_to :fiscal_year
  belongs_to :account
  belongs_to :customer
  belongs_to :annex, :class_name => 'Annex'

  validates_presence_of :fiscal_year_id, :account_id, :amount

  before_validation_on_create :set_attachment_no
  before_save :set_customer

  HUMANIZED_ATTRIBUTES = {
    :account_id => I18n.t(:account_id, :scope => :transaction),
    :amount => I18n.t(:amount, :scope => :transaction)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  attr_accessor :customer_name

  def customer_name
    @customer_name || (self.customer.name if self.customer)
  end
  
  def authenticated_url(expires_in = 10.seconds)
    AWS::S3::S3Object.url_for(annex.attachment.path, annex.attachment.bucket_name, :expires_in => expires_in, :use_ssl => annex.attachment.s3_protocol == 'https')
  end

  def set_attachment_no
    self.attachment_no = (self.fiscal_year.transactions.maximum(:attachment_no) || 0) + 1 if self.attachment_no == 0
  end

  def set_customer
    self.customer = self.fiscal_year.user.customers.find_or_create_by_name(self.customer_name) unless self.customer_name.blank?
  end

end