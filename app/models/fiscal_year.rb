class FiscalYear < ActiveRecord::Base
  has_many :postings, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  belongs_to :user
  
end
