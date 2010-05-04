class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :postings, :dependent => :nullify
  has_many :transactions, :dependent => :nullify
  
  validates_presence_of :user_id, :name
  
  HUMANIZED_ATTRIBUTES = {
    :name => I18n.t(:name, :scope => :customer)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  attr_accessible :name, :description
  
  def income(fiscal_year, currency)
    transactions.to_a.find_all { |t| t.fiscal_year_id == fiscal_year.id && t.transaction_type == Transaction::TRANSACTION_TYPES[:sell] }.sum do |t|
      t.amount_in(currency)
    end
  end

  def expense(fiscal_year, currency)
    transactions.to_a.find_all { |t| t.fiscal_year_id == fiscal_year.id && t.transaction_type == Transaction::TRANSACTION_TYPES[:buy] }.sum do |t|
      t.amount_in(currency)
    end
  end
  
end
