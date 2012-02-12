# encoding: utf-8

class Account < ActiveRecord::Base
  ACCOUNT_TYPES = { :heading => 1, :operating => 2, :status => 3, :sum => 4 }
  VAT_TYPES =  { :income => 1, :expense => 2, :hotel => 3, :none => 4 }
  
  belongs_to :user
  
  validates_presence_of :name
  validates_presence_of :account_type
  validates_presence_of :vat_type
  
  HUMANIZED_ATTRIBUTES = {
    :name => I18n.t(:name, :scope => :account),
    :account_type => I18n.t(:account_type, :scope => :account),
    :vat_type => I18n.t(:vat_type, :scope => :account)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  attr_accessible :name, :description, :account_type, :vat_type, :account_no, :aggregate_from_account_no
  
end