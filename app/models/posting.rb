class Posting < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  
  validates_presence_of :account_id
  validates_presence_of :amount
  
end
