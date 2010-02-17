class FiscalYear < ActiveRecord::Base
  has_many :postings, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :name, :start_date, :end_date
  
end
