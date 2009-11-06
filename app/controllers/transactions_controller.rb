class TransactionsController < ApplicationController
  before_filter :authenticate, :get_fiscal_year
  
  def index
    @transactions = @fiscal_year.transactions.all(:include => [:customer, :annexes], :order => 'created_at DESC')

    @total_income = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:sell]])
    @total_expense = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:buy]])
    
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
        @total_income = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:sell]])
        @total_expense = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:buy]])
        
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
        @total_income = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:sell]])
        @total_expense = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:buy]])
        
        format.js
      else
        format.js
      end
    end
  end
  
  def destroy
    @transaction = @fiscal_year.transactions.find(params[:id])
    @transaction.destroy

    @total_income = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:sell]])
    @total_expense = @fiscal_year.transactions.sum('amount', :conditions => ['transaction_type = ?', Transaction::TRANSACTION_TYPES[:buy]])
    
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def get_fiscal_year
    @fiscal_year = current_user.fiscal_years.find(params[:fiscal_year_id])
  end
end
