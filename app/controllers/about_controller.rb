# encoding: utf-8

class AboutController < ApplicationController
  before_filter :authorize, :only => [:overview]
  before_filter :redirect_to_overview, :only => :index
  
  def index
    render :layout => 'frontpage'
  end
  
  def overview
    @transactions_with_wrong_fiscal_year = current_user.active_fiscal_year.transactions.wrong_fiscal_year
    @incomplete_transactions = current_user.active_fiscal_year.transactions.incomplete
    @transactions_without_related_transactions = current_user.active_fiscal_year.transactions.without_related_transactions
    
    latest_import = current_user.posting_imports.first(:order => 'created_at DESC')
    @late_import = latest_import && (1.month.ago > latest_import.created_at)
    
    @action_required = @transactions_with_wrong_fiscal_year.any? || @incomplete_transactions.any? || @transactions_without_related_transactions.any? || @late_import
    
    if @transactions_with_wrong_fiscal_year.any?
      @other_fiscal_years = current_user.fiscal_years.delete_if { |fy| fy == current_user.active_fiscal_year }
    end
    
    @incomes = current_user.active_fiscal_year.transactions.income.group_by(&:currency).map { |a, b| [a, b.sum(&:amount)] }
    @expenses = current_user.active_fiscal_year.transactions.expense.group_by(&:currency).map { |a, b| [a, b.sum(&:amount)] }
    
    @latest_transactions = current_user.active_fiscal_year.transactions.latest
  end
  
  def help
    @exchange_rates = ExchangeRate.latest.all(:order => 'currency')
    
  end
  
  def ping
    Inbox.new.perform
    render :text => 'ok'
  end
  
  def privacy
    
  end
  
  private
  
  def redirect_to_overview
    redirect_to :overview if signed_in?
  end
  
end