class User < ActiveRecord::Base
  include Clearance::User
  
  has_many :postings, :dependent => :destroy
  has_many :accounts, :dependent => :destroy
  has_many :customers, :dependent => :destroy
  has_many :fiscal_years, :dependent => :destroy
  belongs_to :active_fiscal_year, :class_name => 'FiscalYear'
  
  after_create :setup_default_accounts, :set_active_fiscal_year
  
  attr_accessible :company, :cvr
  
  validates_presence_of :company
  validates_format_of :cvr, :with => /^[\d]+$/, :allow_nil => true, :allow_blank => true
  validates_length_of :cvr, :is => 8, :allow_nil => true, :allow_blank => true

  HUMANIZED_ATTRIBUTES = {
    :company => I18n.t(:company, :scope => :user),
    :email => I18n.t(:email, :scope => :user),
    :password => I18n.t(:password, :scope => :user)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def default_currency
    'DKK'
  end
  
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
  
  def set_active_fiscal_year
    if self.active_fiscal_year.nil?
      current_year = Date.today.year
      year = self.fiscal_years.create(:start_date => Date.new(current_year), :end_date => (Date.new(current_year + 1) - 1.day), :name => 'Regnskab ' + current_year.to_s)
      self.update_attribute(:active_fiscal_year_id, year.id)
    end
  end
  
end