class AnnexesController < ApplicationController
  before_filter :authenticate, :get_transaction

  def show
    @annex = @transaction.annexes.find(params[:id])
  end
  
  def destroy
    @annex = @transaction.annexes.find(params[:id])
    @annex.destroy
    
    respond_to do |format|
      format.html { redirect_to fiscal_year_transactions_url(@transaction.fiscal_year) }
    end
  end
  
  def download
    @annex = @transaction.annexes.find(params[:id])

    redirect_to @annex.authenticated_url
  end
  
  def preview
    @annex = @transaction.annexes.find(params[:id])
    
    @format_as = params[:as]
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  private
  
  def get_transaction
    @transaction = current_user.fiscal_years.find(params[:fiscal_year_id]).transactions.find(params[:transaction_id])
  end
  
end