class AccountsController < ApplicationController
  before_filter :authenticate
  
  def index
    @accounts = current_user.accounts.all
    
    @account = current_user.accounts.new
    
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

  # DELETE /accounts/1
  def destroy
    @account = current_user.accounts.find(params[:id])
    @account.destroy
    
    respond_to do |format|
      format.js
    end
  end
  
end
