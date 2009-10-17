class ReportsController < ApplicationController
  before_filter :authenticate
  
  def index
    @total_income = current_user.active_fiscal_year.postings.total_selling(2009).sum(:amount)
    @total_expenses = current_user.active_fiscal_year.postings.total_buying(2009).sum(:amount)

    # @total_income_months = current_user.active_fiscal_year.postings.total_selling(2009).group_by(&:month)
    # @total_expenses_months = current_user.active_fiscal_year.postings.total_buying(2009).group_by(&:month)

    total_income_months = current_user.active_fiscal_year.postings.find(:all, :select => 'extract(month from postings.created_at) AS month, SUM(postings.amount) AS amount', :joins => :account, :conditions => ['EXTRACT (YEAR FROM postings.created_at) = ? AND accounts.account_type = ?', 2009, Account::ACCOUNT_TYPES[:sell]], :order => '(extract(month from postings.created_at))', :group => '(extract(month from postings.created_at))')
    total_expenses_months = current_user.active_fiscal_year.postings.find(:all, :select => 'extract(month from postings.created_at) AS month, SUM(postings.amount) AS amount', :joins => :account, :conditions => ['EXTRACT (YEAR FROM postings.created_at) = ? AND accounts.account_type = ?', 2009, Account::ACCOUNT_TYPES[:buy]], :order => '(extract(month from postings.created_at))', :group => '(extract(month from postings.created_at))')
    
    @total_months = []
    (1..12).each do |i|
      income = total_income_months.find { |a| a[:month] == i.to_s }
      expenses = total_expenses_months.find { |a| a[:month] == i.to_s }
      @total_months << {
        :month => i.to_s,
        :income_amount => (income[:amount] if income) || '0.0',
        :expenses_amount => (expenses[:amount] if expenses) || '0.0'
      }
    end
  end
end
