class AccountsController < ApplicationController
  before_filter :authenticate
  
  def index
    @accounts = current_user.accounts.all
    
    @account = current_user.accounts.new
    
  end
  
  # POST /accounts
  def create
    @account = current_user.accounts.new(params[:account])

    respond_to do |format|
      if @account.save
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to(accounts_url) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
