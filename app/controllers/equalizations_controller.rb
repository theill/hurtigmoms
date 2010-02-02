class EqualizationsController < ApplicationController
  before_filter :authenticate, :get_transaction
  
  def create
    @equalization = @transaction.equalizations.new(params[:equalization])

    respond_to do |format|
      if @equalization.save
        format.js
      else
        format.js
      end
    end
  end
  
  def destroy
    @equalization = @transaction.equalizations.find(params[:id])
    @equalization.destroy

    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def get_transaction
    @transaction = current_user.fiscal_years.find(params[:fiscal_year_id]).transactions.find(params[:transaction_id])
  end
  
end