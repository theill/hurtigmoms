class PostingsController < ApplicationController
  before_filter :authenticate
  
  # GET /postings
  # GET /postings.xml
  def index
    @postings = current_user.postings.all(:include => :account, :order => 'created_at DESC')
    
    @total_selling = current_user.postings.total_selling.sum(:amount)
    @total_buying = current_user.postings.total_buying.sum(:amount)
    
    @posting = current_user.postings.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @postings }
    end
  end
  
  # GET /postings/1
  # GET /postings/1.xml
  def show
    @posting = current_user.postings.find(params[:id])
    
    respond_to do |format|
      format.xml  { render :xml => @posting }
      format.js
    end
  end
  
  # GET /postings/new
  # GET /postings/new.xml
  def new
    @posting = current_user.postings.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @posting }
      format.js
    end
  end
  
  # GET /postings/1/edit
  def edit
    @posting = current_user.postings.find(params[:id])
  end
  
  # POST /postings
  # POST /postings.xml
  def create
    @posting = current_user.postings.new(params[:posting])
    
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
    @posting = current_user.postings.find(params[:id])
    
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
    @posting = current_user.postings.find(params[:id])
    @posting.destroy
    
    respond_to do |format|
      format.xml  { head :ok }
      format.js
    end
  end
  
  def download
    # http://docs.google.com/viewer
		# <a href="http://docs.google.com/viewer?url=<%= @posting.authenticated_url %>&embedded=true">vis bilag</a>

    @posting = current_user.postings.find(params[:id])
    
    redirect_to @posting.authenticated_url
  end
end
