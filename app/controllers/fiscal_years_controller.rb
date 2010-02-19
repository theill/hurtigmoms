class FiscalYearsController < ApplicationController
  before_filter :authenticate
  
  def index
    @fiscal_years = current_user.fiscal_years
  end
  
  def new
    @fiscal_year = current_user.fiscal_years.new
  end
  
  def edit
    @fiscal_year = current_user.fiscal_years.find(params[:id])
  end
  
  def create
    @fiscal_year = current_user.fiscal_years.new(params[:fiscal_year])

    respond_to do |format|
      if @fiscal_year.save
        flash[:notice] = 'FiscalYear was successfully created.'
        format.html { redirect_to(fiscal_years_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @fiscal_year = current_user.fiscal_years.find(params[:id])

    respond_to do |format|
      if @fiscal_year.update_attributes(params[:fiscal_year])
        flash[:notice] = 'FiscalYear was successfully updated.'
        format.html { redirect_to(fiscal_years_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def overview
    fiscal_year = current_user.fiscal_years.find(params[:id], :include => :transactions)
    
    @transactions = fiscal_year.transactions.payments.all(:include => [:linked_from, :linked_to, :annexes, :customer], :order => 'transactions.created_at DESC')

    @unrealized_income = fiscal_year.transactions.filter_by_type(Transaction::TRANSACTION_TYPES[:sell]).all(:order => 'transactions.created_at DESC').delete_if { |t| t.equalizations.count > 0 }
    @not_afstemt_expense = fiscal_year.transactions.filter_by_type(Transaction::TRANSACTION_TYPES[:buy]).all(:order => 'transactions.created_at DESC').delete_if { |t| t.equalizations.count > 0 }
    
  end
  
  def download_annexes
    @fiscal_year = current_user.fiscal_years.find(params[:id])
    t = @fiscal_year.zip_annexes
    
    # Send it using the right mime type, with a download window and some nice file name.
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@fiscal_year.name.parameterize.to_s}-#{@fiscal_year.user.company.parameterize.to_s}.zip"

    # The temp file will be deleted some time...
    t.close
  end
  
end
