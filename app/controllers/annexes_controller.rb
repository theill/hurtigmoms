class AnnexesController < ApplicationController
  before_filter :authenticate, :get_transaction
  
  def download
    @annex = @transaction.annexes.find(params[:id])

    redirect_to @annex.authenticated_url
  end
  
  private
  
  def get_transaction
    @transaction = current_user.fiscal_years.find(params[:fiscal_year_id]).transactions.find(params[:transaction_id])
  end
  
end