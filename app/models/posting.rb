class Posting < ActiveRecord::Base
  belongs_to :account
  belongs_to :customer
  belongs_to :fiscal_year
  
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 'amazon_s3.yml'),
    :s3_permissions => 'authenticated-read',
    :url => ':s3_domain_url',
    :path => ":attachment/:id/:style.:extension",
    :bucket => 'hurtigmoms'
    
  STATES = { :accepted => 'A', :pending => 'P', :imported => 'I', :deleted => 'D' }
  
  validates_presence_of :fiscal_year_id
  validates_presence_of :account_id
  validates_presence_of :amount
  validates_presence_of :currency

  HUMANIZED_ATTRIBUTES = {
    :account_id => I18n.t(:account_id, :scope => :posting),
    :amount => I18n.t(:amount, :scope => :posting)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  named_scope :total_income, lambda { |year| { :joins => :account, :conditions => ['EXTRACT (YEAR FROM postings.created_at) = ? AND accounts.account_no >= 1000 AND accounts.account_no < 1300', year] } }
  named_scope :total_expense, lambda { |year| { :joins => :account, :conditions => ['EXTRACT (YEAR FROM postings.created_at) = ? AND accounts.account_no >= 1300 AND accounts.account_no < 5000', year] } }

  before_validation_on_create :set_attachment_no, :set_currency
  before_save :reset_state, :set_customer
  # after_create :adjust_operating_accounts, :adjust_vat_accounts
  
  attr_accessor :customer_name, :vat_of_amount
  
  def month
    self.created_at.strftime('%m')
  end
  
  def customer_name
    @customer_name || (self.customer.name if self.customer)
  end
  
  def vat_of_amount
    self.amount * 0.20
  end
    
  def authenticated_url(expires_in = 10.seconds)
    AWS::S3::S3Object.url_for(attachment.path, attachment.bucket_name, :expires_in => expires_in, :use_ssl => attachment.s3_protocol == 'https')
  end
  
  def google_viewer_url
    "http://docs.google.com/viewer?url=#{CGI::escape(self.authenticated_url)}&embedded=true"
  end
    
  def next_attachment_no
    self.attachment_no + 1
  end
  
  def pdf?
    self.attachment? && self.attachment_content_type == 'application/pdf'
  end
  
  def set_attachment_no
    self.attachment_no = (self.fiscal_year.postings.maximum(:attachment_no) || 0) + 1 if self.attachment_no == 0
  end

  protected
  
  def set_currency
    self.currency = self.fiscal_year.user.default_currency if self.currency.nil?
  end
  
  def reset_state
    if (self.amount.blank? || self.amount.to_f == 0.0 || self.currency.blank? || self.created_at.blank?)
      self.state = Posting::STATES[:pending]
    else
      self.state = Posting::STATES[:accepted]
    end
  end
  
  def set_customer
    self.customer = self.fiscal_year.user.customers.find_or_create_by_name(self.customer_name) unless self.customer_name.blank?
  end
  
  # def adjust_operating_accounts
  #   return unless (self.account.account_type == Account::ACCOUNT_TYPES[:operating])
  # 
  #   u = self.fiscal_year.user
  # 
  #   if self.account.account_no >= 1000 && self.account.account_no < 1300
  #     if self.account.account_type == Account::ACCOUNT_TYPES[:operating]
  #       debitor_account = u.accounts.find_by_account_no(5600)
  #       debitor_account.update_attribute(:amount, debitor_account.amount + self.amount)
  #     end
  #     
  #     # 'income accounts' will be credited
  #     self.account.update_attribute(:amount, self.account.amount + (-1 * self.amount))
  #   elsif self.account.account_no >= 1300
  #     if self.account.account_type == Account::ACCOUNT_TYPES[:operating]
  #       creditor_account = u.accounts.find_by_account_no(6800)
  #       creditor_account.update_attribute(:amount, creditor_account.amount + (-1 * self.amount))
  #     end
  #     
  #     # all other accounts will be debited
  #     self.account.update_attribute(:amount, self.account.amount + self.amount)
  #   end
  # end
  # 
  # def adjust_vat_accounts
  #   return unless (self.account.account_type == Account::ACCOUNT_TYPES[:operating])
  #   
  #   u = self.fiscal_year.user
  #   
  #   if self.account.vat_type == Account::VAT_TYPES[:income]
  #     sell_vat_account = u.accounts.find_by_account_no(6901)
  #     u.active_fiscal_year.postings.create(:account => sell_vat_account, :amount => -1 * self.vat_of_amount, :attachment_no => self.attachment_no)
  #     sell_vat_account.update_attribute(:amount, sell_vat_account.amount + (-1 * self.vat_of_amount))
  #   elsif self.account.vat_type == Account::VAT_TYPES[:expense]
  #     buy_vat_account = u.accounts.find_by_account_no(6902)
  #     u.active_fiscal_year.postings.create(:account => buy_vat_account, :amount => self.vat_of_amount, :attachment_no => self.attachment_no)
  #     buy_vat_account.update_attribute(:amount, buy_vat_account.amount + self.vat_of_amount)
  #   end
  # end
  
end