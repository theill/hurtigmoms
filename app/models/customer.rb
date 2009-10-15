class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :postings, :dependent => :nullify
  
  validates_presence_of :user_id, :name
  
  HUMANIZED_ATTRIBUTES = {
    :name => I18n.t(:name, :scope => :customer)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  attr_accessible :name, :description
  
end
