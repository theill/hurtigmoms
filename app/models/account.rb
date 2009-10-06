class Account < ActiveRecord::Base
  ACCOUNT_TYPES = { :sell => 1, :buy => 2 }
  VAT_TYPES =  { :standard => 1, :none => 2, :other_country => 3 }
  
  belongs_to :user
  named_scope :buying, :conditions => ['account_type = ?', ACCOUNT_TYPES[:buy]]
  named_scope :selling, :conditions => ['account_type = ?', ACCOUNT_TYPES[:sell]]
  
  validates_presence_of :name
  validates_presence_of :account_type
  validates_presence_of :vat_type
  
  attr_accessible :name, :account_type, :vat_type, :account_no
  
end
