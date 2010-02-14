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
  
end
