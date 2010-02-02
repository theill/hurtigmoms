class AboutController < ApplicationController
  def index
    render :layout => 'frontpage' and return unless signed_in?
    
    @action_required = current_user.active_fiscal_year.transactions.incomplete.length > 0
    @latest_import = current_user.posting_imports.find(:first, :order => 'created_at DESC')
  end
  
  def help
    @exchange_rates = ExchangeRate.all(:order => 'currency')
    
  end
end