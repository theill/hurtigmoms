class User < ActiveRecord::Base
  include Clearance::User
  
  has_many :postings, :dependent => :destroy
  has_many :accounts, :dependent => :destroy
  has_many :customers, :dependent => :destroy
  
  after_create :setup_default_accounts
  
  attr_accessible :company, :cvr
  
  validates_presence_of :company
  validates_format_of :cvr, :with => /^[\d]+$/, :allow_nil => true, :allow_blank => true
  validates_length_of :cvr, :is => 8, :allow_nil => true, :allow_blank => true
  
  protected
  
  def setup_default_accounts
    [ ['0120', 'Salg, indland', Account::VAT_TYPES[:standard]], 
      ['0137', 'Salg, EU-lande', Account::VAT_TYPES[:other_country]],
      ['0138', 'Salg, øvrige lande', Account::VAT_TYPES[:other_country]]
    ].each do |account_no, name, vat|
      self.accounts.create(:name => name, :account_no => account_no, :vat_type => vat, :account_type => Account::ACCOUNT_TYPES[:sell])
    end

    [ ['1300', 'Varekøb, indland', Account::VAT_TYPES[:standard]], 
      ['1307', 'Varekøb, EU-lande', Account::VAT_TYPES[:other_country]],
      ['1308', 'Varekøb, øvrige lande', Account::VAT_TYPES[:other_country]],
      ['2754', 'Gaver og blomster', Account::VAT_TYPES[:standard]],
      ['3421', 'Husleje', Account::VAT_TYPES[:standard]],
      ['3425', 'El, vand og varme', Account::VAT_TYPES[:standard]],
      ['3617', 'Småanskaffelser', Account::VAT_TYPES[:standard]],
      ['3622', 'Telefon', Account::VAT_TYPES[:standard]],
      ['3623', 'Internet', Account::VAT_TYPES[:standard]],
      ['3628', 'Porto og gebyrer', Account::VAT_TYPES[:standard]],
      ['3640', 'Revisor', Account::VAT_TYPES[:standard]],
      ['3642', 'Advokat', Account::VAT_TYPES[:standard]],
      ['3660', 'Faglitteratur', Account::VAT_TYPES[:standard]],
      ['3661', 'Avis', Account::VAT_TYPES[:none]]
    ].each do |account_no, name, vat|
      self.accounts.create(:name => name, :account_no => account_no, :vat_type => vat, :account_type => Account::ACCOUNT_TYPES[:buy])
    end
  end
  
end
