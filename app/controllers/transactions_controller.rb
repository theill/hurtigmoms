class TransactionsController < ApplicationController
  before_filter :authenticate, :get_fiscal_year
  
  def index
    # @start_date = @fiscal_year.start_date
    # @end_date = @fiscal_year.end_date
    @start_date, @end_date, @transaction_type = nil, nil, params[:transaction_type]
    
    @transactions = @fiscal_year.transactions.search(params[:page], :search => params[:search], :start_date => @start_date, :end_date => @end_date, :transaction_type => @transaction_type)
    
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
        matcher = TransactionMatcher.new(@fiscal_year.transactions.payments.all)
        @transaction.save if matcher.match(@transaction)
        
        format.js
      else
        format.js
      end
    end
  end
  
  def update
    @transaction = @fiscal_year.transactions.find(params[:id])
    
    @quick = params[:quick]
    
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        if @transaction.related_transactions.empty?
          matcher = TransactionMatcher.new(@fiscal_year.transactions.payments.all)
          @transaction.save if matcher.match(@transaction)
        end
        format.html { redirect_to(params[:return_to] || fiscal_year_transactions_url(@fiscal_year)) }
        format.js {}
      else
        format.html { redirect_to(params[:return_to] || fiscal_year_transactions_url(@fiscal_year)) }
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
  
  def auto_correct
    @transactions = @fiscal_year.transactions.wrong_fiscal_year
    
    fiscal_year = current_user.fiscal_years.find(params[:corrected_fiscal_year_id]) rescue nil
    if fiscal_year.nil?
      fiscal_year = current_user.fiscal_years.create(:name => 'Regnskab ' + (@fiscal_year.end_date + 1.day).year.to_s, :start_date => @fiscal_year.end_date + 1.day, :end_date => @fiscal_year.end_date + 1.year)
    end
    
    @transactions.each do |t|
      t.update_attribute(:fiscal_year, fiscal_year)
    end
    
    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
  
  def search
    @transactions = @fiscal_year.transactions.search(params[:page] || 1, :search => params[:search])
    
    respond_to do |format|
      format.js
    end
  end
  
  # check for new transactions
  def ping
    @transactions = @fiscal_year.transactions.all(:conditions => ['created_at > ?', 10.minutes.ago], :order => 'created_at DESC')
    
    respond_to do |format|
      format.js
    end    
  end
  
  private
  
  def get_fiscal_year
    @fiscal_year = current_user.fiscal_years.find(params[:fiscal_year_id])
  end
end
