class Transaction < ActiveRecord::Base
  TRANSACTION_TYPES = { :buy => 1, :sell => 2, :pay => 3 }
  
  belongs_to :fiscal_year
  belongs_to :account
  belongs_to :annex, :class_name => 'Annex'

  validates_presence_of :fiscal_year_id, :account_id, :amount

end