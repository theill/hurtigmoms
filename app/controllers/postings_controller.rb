class PostingsController < ApplicationController
  before_filter :authenticate, :get_fiscal_year
  
  # GET /postings
  # GET /postings.xml
  def index
    @postings = @fiscal_year.postings.all(:include => [:account, :customer], :order => 'created_at DESC')
    
    @total_income = @fiscal_year.postings.total_income(2009).sum(:amount)
    @total_expense = @fiscal_year.postings.total_expense(2009).sum(:amount)
    
    @bank_initial = 0
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postings }
    end
  end
  
  # GET /postings/1
  # GET /postings/1.xml
  def show
    @posting = @fiscal_year.postings.find(params[:id])
    
    respond_to do |format|
      format.xml  { render :xml => @posting }
      format.js
    end
  end
  
  # GET /postings/new
  # GET /postings/new.xml
  def new
    @posting = @fiscal_year.postings.new
    @posting.set_attachment_no
    
    respond_to do |format|
      format.xml  { render :xml => @posting }
      format.js
    end
  end
  
  # GET /postings/1/edit
  def edit
    @posting = @fiscal_year.postings.find(params[:id])
    
    respond_to do |format|
      format.xml  { render :xml => @posting }
      format.js
    end
  end
  
  # POST /postings
  # POST /postings.xml
  def create
    @posting = @fiscal_year.postings.new(params[:posting])
    
    respond_to do |format|
      if @posting.save
        format.xml  { render :xml => @posting, :status => :created, :location => @posting }
        format.js
      else
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end
  
  # PUT /postings/1
  # PUT /postings/1.xml
  def update
    @posting = @fiscal_year.postings.find(params[:id])
    
    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        format.xml  { head :ok }
        format.js
      else
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end
  
  # DELETE /postings/1
  # DELETE /postings/1.xml
  def destroy
    @posting = @fiscal_year.postings.find(params[:id])
    @posting.destroy
    
    respond_to do |format|
      format.xml  { head :ok }
      format.js
    end
  end
  
  def download
    # http://docs.google.com/viewer
    # <a href="http://docs.google.com/viewer?url=<%= @posting.authenticated_url %>&embedded=true">vis bilag</a>

    @posting = @fiscal_year.postings.find(params[:id])
    
    redirect_to @posting.authenticated_url
  end
    
  private
  
  def get_fiscal_year
    @fiscal_year = current_user.fiscal_years.find(params[:fiscal_year_id])
  end
end
