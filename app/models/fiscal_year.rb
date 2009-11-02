class FiscalYear < ActiveRecord::Base
  has_many :postings
  has_many :transactions
  belongs_to :user
  
end
