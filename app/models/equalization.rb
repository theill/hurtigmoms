class Equalization < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :related_transaction, :class_name => 'Transaction'
  
  validates_presence_of :transaction, :related_transaction
  
  def adjust_amount(t)
    if t.amount == 0.0 && self.related_transaction.amount != 0.0
      t.update_attribute(:amount, self.related_transaction.amount)
    end
  end
  
end
