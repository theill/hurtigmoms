class Posting < ActiveRecord::Base
  belongs_to :user
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
    
  STATES = { :accepted => 'A', :pending => 'P', :deleted => 'D' }
  
  # validates_uniqueness_of :attachment_no, :scope => :user_id
  validates_presence_of :user_id
  validates_presence_of :account_id
  validates_presence_of :amount
  validates_presence_of :attachment_no
  validates_presence_of :currency

  HUMANIZED_ATTRIBUTES = {
    :account_id => I18n.t(:account_id, :scope => :posting),
    :amount => I18n.t(:amount, :scope => :posting)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  named_scope :total_buying, lambda { |year| { :joins => :account, :conditions => ['EXTRACT (YEAR FROM postings.created_at) = ? AND accounts.account_type = ?', year, Account::ACCOUNT_TYPES[:buy]] } }
  named_scope :total_selling, lambda { |year| { :joins => :account, :conditions => ['EXTRACT (YEAR FROM postings.created_at) = ? AND accounts.account_type = ?', year, Account::ACCOUNT_TYPES[:sell]] } }

  before_validation_on_create :set_attachment_no, :set_currency
  before_save :reset_state, :set_customer
  
  attr_accessor :customer_name
  
  def month
    self.created_at.strftime('%m')
  end
  
  def customer_name
    @customer_name || (self.customer.name if self.customer)
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
    self.attachment_no = (self.user.postings.maximum(:attachment_no) || 0) + 1 if self.attachment_no == 0
  end

  protected
  
  def set_currency
    self.currency = 'DKK' if self.currency.nil?
  end
  
  def reset_state
    if (self.amount.blank? || self.amount.to_f == 0.0 || self.currency.blank? || self.created_at.blank?)
      self.state = Posting::STATES[:pending]
    else
      self.state = Posting::STATES[:accepted]
    end
  end
  
  def set_customer
    self.customer = self.user.customers.find_or_create_by_name(self.customer_name) unless self.customer_name.blank?
  end
  
end