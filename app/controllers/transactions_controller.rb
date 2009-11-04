class TransactionsController < ApplicationController
  before_filter :authenticate, :get_fiscal_year
  
  def index
    @transactions = @fiscal_year.transactions.all(:include => [:customer], :order => 'created_at DESC')
    
    # if params[:filter] == 'income'
    #   @transactions = @transactions.find_all { |t| t.transaction_type == Transaction::TRANSACTION_TYPES[:sell] }
    # elsif params[:filter] == 'expense'
    #   @transactions = @transactions.find_all { |t| t.transaction_type == Transaction::TRANSACTION_TYPES[:buy] }
    # end
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @transaction = @fiscal_year.transactions.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end
  
  def new
    @transaction = @fiscal_year.transactions.new
    @transaction.set_attachment_no
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit
    @transaction = @fiscal_year.transactions.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @transaction = @fiscal_year.transactions.new(params[:transaction])
    
    respond_to do |format|
      if @transaction.save
        format.js
      else
        format.js
      end
    end
  end
  
  def update
    @transaction = @fiscal_year.transactions.find(params[:id])
    
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.js
      else
        format.js
      end
    end
  end
  
  def destroy
    @transaction = @fiscal_year.transactions.find(params[:id])
    @transaction.destroy
    
    respond_to do |format|
      format.js
    end
  end
  
  def download
    @transaction = @fiscal_year.transactions.find(params[:id])
    
    redirect_to @transaction.authenticated_url
  end
    
  private
  
  def get_fiscal_year
    @fiscal_year = current_user.fiscal_years.find(params[:fiscal_year_id])
  end
end
