class Equalization < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :related_transaction, :class_name => 'Transaction'
  
  validates_presence_of :transaction, :related_transaction
  
end
