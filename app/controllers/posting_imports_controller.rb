# encoding: utf-8

class PostingImportsController < ApplicationController
  before_filter :authorize
  
  # GET /posting_imports/1
  # GET /posting_imports/1.xml
  def show
    @posting_import = current_user.posting_imports.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @posting_import }
    end
  end

  # GET /posting_imports/new
  # GET /posting_imports/new.xml
  def new
    @posting_import = current_user.posting_imports.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @posting_import }
    end
  end

  # GET /posting_imports/1/edit
  def edit
    @posting_import = current_user.posting_imports.find(params[:id])
    
    @rows = @posting_import.parse
    if @rows.blank?
      flash[:failure] = "Det var ikke muligt at indlæse den angive fil."
      render :action => :new
    end
  end

  # POST /posting_imports
  # POST /posting_imports.xml
  def create
    @posting_import = current_user.posting_imports.new(params[:posting_import])

    respond_to do |format|
      if @posting_import.save
        format.html { redirect_to(edit_posting_import_path(@posting_import)) }
        format.xml  { render :xml => @posting_import, :status => :created, :location => @posting_import }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @posting_import.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posting_imports/1
  # PUT /posting_imports/1.xml
  def update
    @posting_import = current_user.posting_imports.find(params[:id])
    
    respond_to do |format|
      if @posting_import.update_attributes(params[:posting_import])
        @import_count, @duplicate_count, @failed_count = @posting_import.import
        format.html { redirect_to(@posting_import) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @posting_import.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posting_imports/1
  # DELETE /posting_imports/1.xml
  def destroy
    @posting_import = current_user.posting_imports.find(params[:id])
    @posting_import.destroy

    respond_to do |format|
      format.html { redirect_to(posting_imports_url) }
      format.xml  { head :ok }
    end
  end
end
