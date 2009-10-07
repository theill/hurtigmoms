class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :postings, :dependent => :nullify
  
  validates_presence_of :user_id, :name
  
  attr_accessible :name, :description
  
end
