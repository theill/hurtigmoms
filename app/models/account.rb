class Account < ActiveRecord::Base
  ACCOUNT_TYPES = { :selling => 1, :buying => 2 }
  
  belongs_to :user
  named_scope :buying, :conditions => ['account_type = ?', ACCOUNT_TYPES[:buying]]
  named_scope :selling, :conditions => ['account_type = ?', ACCOUNT_TYPES[:selling]]
  
  validates_presence_of :name
  validates_presence_of :account_type
  validates_presence_of :vat_type
  
  
end
