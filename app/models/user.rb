class User < ActiveRecord::Base
  include Clearance::User
  
  has_many :postings
  has_many :accounts
  
  after_create :setup_default_accounts
  
  protected
  
  def setup_default_accounts
    self.accounts.create(:name => 'Salg indland', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    self.accounts.create(:name => 'Salg indland, hardware', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    self.accounts.create(:name => 'Salg indland, software', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    self.accounts.create(:name => 'Andet salg', :account_type => Account::ACCOUNT_TYPES[:selling], :vat_type => 1)
    
    self.accounts.create(:name => 'Varekøb', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Annonceringer', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Domæner', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Frimærker', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Taxakørsel', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Flybilletter', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Togrejser', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Internet', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Kontorartikler', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Mindre anskaffelser', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Revisor', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Advokat', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Aviser', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Faglitteratur', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Forsikringer', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Gaver og blomster', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Telefon', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Husleje', :account_type => 2, :vat_type => 1)
    self.accounts.create(:name => 'Moms', :account_type => 2, :vat_type => 1)
  end
  
end
