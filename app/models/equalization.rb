class Equalization < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :related_transaction, :class_name => 'Transaction'#, :foreign_key => 'related_transaction_id'
  
  validates_presence_of :transaction, :related_transaction
  
  def adjust_amount(t)
    if t.amount == 0.0 && self.related_transaction.amount != 0.0
      # FIXME: negative values should be considered
      adjusted_amount = self.related_transaction.amount
      t.update_attribute(:amount, adjusted_amount)
    end
  end
  
end
