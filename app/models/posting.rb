class Posting < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
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
  
  named_scope :total_buying, :joins => :account, :conditions => ['accounts.account_type = ?', Account::ACCOUNT_TYPES[:buying]]
  named_scope :total_selling, :joins => :account, :conditions => ['accounts.account_type = ?', Account::ACCOUNT_TYPES[:selling]]
  
  before_validation_on_create :set_attachment_no, :set_currency
  
  def authenticated_url(expires_in = 10.seconds)
    AWS::S3::S3Object.url_for(attachment.path, attachment.bucket_name, :expires_in => expires_in, :use_ssl => attachment.s3_protocol == 'https')
  end
  
  def google_viewer_url
    "http://docs.google.com/viewer?url=#{CGI::escape(self.authenticated_url)}&embedded=true"
  end
  
  def after_initialize
    self.set_attachment_no
  end
  
  def next_attachment_no
    self.attachment_no + 1
  end
  
  protected
  
  def set_attachment_no
    self.attachment_no = (self.user.postings.maximum(:attachment_no) || 0) + 1 if self.attachment_no == 0
  end
  
  def set_currency
    self.currency = 'DKK' if self.currency.nil?
  end
  
end