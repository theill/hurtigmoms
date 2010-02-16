class AboutController < ApplicationController
  def index
    render :layout => 'frontpage' and return unless signed_in?
    
    @transactions_with_wrong_fiscal_year = current_user.active_fiscal_year.transactions.wrong_fiscal_year
    @incomplete_transactions = current_user.active_fiscal_year.transactions.incomplete
    @transactions_without_related_transactions = current_user.active_fiscal_year.transactions.without_related_transactions
    
    @action_required = @transactions_with_wrong_fiscal_year.any? || @incomplete_transactions.any? || @transactions_without_related_transactions.any?
    
    if @transactions_with_wrong_fiscal_year.any?
      @other_fiscal_years = current_user.fiscal_years.delete_if { |fy| fy == current_user.active_fiscal_year }
    end
    
    
    @latest_import = current_user.posting_imports.find(:first, :order => 'created_at DESC')
  end
  
  def help
    @exchange_rates = ExchangeRate.all(:order => 'currency')
    
  end
end