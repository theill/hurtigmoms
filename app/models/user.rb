class User < ActiveRecord::Base
  include Clearance::User
  
  has_many :postings
  has_many :accounts
  
  after_create :setup_default_accounts
  
  attr_accessible :company, :cvr
  
  validates_presence_of :company
  # validates_format_of :cvr, :with => /^[\w\d]+$/, :allow_nil => true, :allow_blank => true
  validates_length_of :cvr, :is => 8, :allow_nil => true
  
  protected
  
  def setup_default_accounts
    self.accounts.create(:name => 'Salg indland', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    self.accounts.create(:name => 'Salg indland, hardware', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    self.accounts.create(:name => 'Salg indland, software', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    self.accounts.create(:name => 'Andet salg', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    
    self.accounts.create(:name => 'Varekøb', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Annonceringer', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Domæner', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Frimærker', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Taxakørsel', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Flybilletter', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Togrejser', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Internet', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Kontorartikler', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Mindre anskaffelser', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Revisor', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Advokat', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Aviser', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Faglitteratur', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Forsikringer', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Gaver og blomster', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => Account::VAT_TYPES[:free])
    self.accounts.create(:name => 'Telefon', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
    self.accounts.create(:name => 'Husleje', :account_type => Account::ACCOUNT_TYPES[:buying], :vat_type => 1)
  end
  
end
