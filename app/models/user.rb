# encoding: utf-8

class User < ActiveRecord::Base
  include Clearance::User
  extend  Clearance::User::ClassMethods
  include Clearance::User::Validations
  include Clearance::User::Callbacks
  
  has_many :accounts, :dependent => :destroy
  has_many :customers, :dependent => :destroy
  has_many :fiscal_years, :dependent => :destroy, :order => 'end_date DESC'
  has_many :posting_imports, :dependent => :destroy
  belongs_to :active_fiscal_year, :class_name => 'FiscalYear'
  
  after_create :setup_default_accounts, :set_active_fiscal_year
  
  attr_accessible :company, :cvr, :dropbox, :active_fiscal_year_id
  
  validates_presence_of :company
  validates_format_of :cvr, :with => /^[\d]+$/, :allow_nil => true, :allow_blank => true
  validates_length_of :cvr, :is => 8, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of :dropbox, :allow_nil => true

  HUMANIZED_ATTRIBUTES = {
    :company => I18n.t(:company, :scope => :user),
    :email => I18n.t(:email, :scope => :user),
    :password => I18n.t(:password, :scope => :user),
    :dropbox => I18n.t(:dropbox, :scope => :user)
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def default_currency
    'DKK'
  end
  
  protected
  
  def setup_default_accounts
    default_account_plan = IO.read("#{Rails.root}/lib/kontoplan-ffr.xls.csv")
    # default_account_plan = Iconv.iconv('utf-8', 'iso8859-1', default_account_plan).join('\n')
    rows = FasterCSV.parse(default_account_plan, {:col_sep => ',', :skip_blanks => true, :headers => true})
    
    rows.each do |r|
      self.accounts.create(:name => r['Navn'], :description => r['Beskrivelse'], :account_no => r['Nr.'], :vat_type => translate_vat_code(r['Momskode']), :account_type => translate_type(r['Type']), :aggregate_from_account_no => r['Sum fra konto'])
    end
    
    # [ ['0120', 'Salg, indland', Account::VAT_TYPES[:standard]], 
    #   ['0137', 'Salg, EU-lande', Account::VAT_TYPES[:other_country]],
    #   ['0138', 'Salg, øvrige lande', Account::VAT_TYPES[:other_country]]
    # ].each do |account_no, name, vat|
    #   self.accounts.create(:name => name, :account_no => account_no, :vat_type => vat, :account_type => Account::ACCOUNT_TYPES[:income])
    # end
    # 
    # [ ['1300', 'Varekøb, indland', Account::VAT_TYPES[:standard]], 
    #   ['1307', 'Varekøb, EU-lande', Account::VAT_TYPES[:other_country]],
    #   ['1308', 'Varekøb, øvrige lande', Account::VAT_TYPES[:other_country]],
    #   ['2754', 'Gaver og blomster', Account::VAT_TYPES[:standard]],
    #   ['3421', 'Husleje', Account::VAT_TYPES[:standard]],
    #   ['3425', 'El, vand og varme', Account::VAT_TYPES[:standard]],
    #   ['3617', 'Småanskaffelser', Account::VAT_TYPES[:standard]],
    #   ['3622', 'Telefon', Account::VAT_TYPES[:standard]],
    #   ['3623', 'Internet', Account::VAT_TYPES[:standard]],
    #   ['3628', 'Porto og gebyrer', Account::VAT_TYPES[:standard]],
    #   ['3640', 'Revisor', Account::VAT_TYPES[:standard]],
    #   ['3642', 'Advokat', Account::VAT_TYPES[:standard]],
    #   ['3660', 'Faglitteratur', Account::VAT_TYPES[:standard]],
    #   ['3661', 'Avis', Account::VAT_TYPES[:none]]
    # ].each do |account_no, name, vat|
    #   self.accounts.create(:name => name, :account_no => account_no, :vat_type => vat, :account_type => Account::ACCOUNT_TYPES[:expense])
    # end
  end
  
  def set_active_fiscal_year
    if self.active_fiscal_year.nil?
      current_year = Date.today.year
      year = self.fiscal_years.create(:start_date => Date.new(current_year), :end_date => (Date.new(current_year + 1) - 1.day), :name => 'Regnskab ' + current_year.to_s)
      self.update_attribute(:active_fiscal_year_id, year.id)
    end
  end
  
  private
  
  def translate_type(name)
    case name
    when 'Tekst'
      Account::ACCOUNT_TYPES[:heading]
    when 'Drift'
      Account::ACCOUNT_TYPES[:operating]
    when 'Status'
      Account::ACCOUNT_TYPES[:status]
    when 'Sum'
      Account::ACCOUNT_TYPES[:sum]
    end
  end
  
  def translate_vat_code(vat_code)
    case vat_code
    when 'Salgsmoms'
      Account::VAT_TYPES[:income]
    when 'Købsmoms'
      Account::VAT_TYPES[:expense]
    when 'Hotelmoms'
      Account::VAT_TYPES[:hotel]
    else
      Account::VAT_TYPES[:none]
    end
  end
  
end