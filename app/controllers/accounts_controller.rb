class AccountsController < ApplicationController
  before_filter :authenticate
  
  def index
    @accounts = current_user.accounts.all
    
    @account = current_user.accounts.new
    
  end

  # GET /accounts/1
  def show
    @account = current_user.accounts.find(params[:id])
    
    respond_to do |format|
      format.xml  { render :xml => @account }
      format.js
    end
  end

  # GET /accounts/new
  def new
    @account = current_user.accounts.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @posting }
      format.js
    end
  end

  # GET /accounts/1/edit
  def edit
    @account = current_user.accounts.find(params[:id])
  end
  
  # POST /accounts
  def create
    @account = current_user.accounts.new(params[:account])
    
    respond_to do |format|
      if @account.save
        format.html { redirect_to(accounts_url) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accounts/1
  def update
    @account = current_user.accounts.find(params[:id])
    
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.xml  { head :ok }
        format.js
      else
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /accounts/1
  def destroy
    @account = current_user.accounts.find(params[:id])
    # FIXME: change state of this account
    
    respond_to do |format|
      format.js
    end
  end
  
end
