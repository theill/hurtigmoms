class CustomersController < ApplicationController
  before_filter :authenticate
  
  # GET /customers
  # GET /customers.xml
  def index
    @customers = current_user.customers.all(:order => 'name')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  def show
    @customer = current_user.customers.find(params[:id])
    
    respond_to do |format|
      format.xml  { render :xml => @customer }
      format.js
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @customer = current_user.customers.new

    respond_to do |format|
      format.html { render :partial => 'edit' } # new.html.erb
      format.js
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = current_user.customers.find(params[:id])
    
    respond_to do |format|
      format.html { render :partial => 'edit' }
      format.js
    end
  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = current_user.customers.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(customers_url) }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = current_user.customers.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to(customers_url) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = current_user.customers.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.js
    end
  end
  
  def search
    @customers = current_user.customers.all(:conditions => ['lower(name) LIKE ?', params[:q].downcase + '%'])

    respond_to do |format|
      format.json { render :json => @customers }
    end
  end
end
