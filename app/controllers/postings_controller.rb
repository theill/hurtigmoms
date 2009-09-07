class PostingsController < ApplicationController
  before_filter :authenticate
  
  # GET /postings
  # GET /postings.xml
  def index
    @postings = current_user.postings.all :order => 'created_at DESC'

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
      format.html # show.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/new
  # GET /postings/new.xml
  def new
    @posting = current_user.postings.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @posting }
    end
  end

  # GET /postings/1/edit
  def edit
    @posting = Posting.find(params[:id])
  end

  # POST /postings
  # POST /postings.xml
  def create
    @posting = current_user.postings.new(params[:posting])

    respond_to do |format|
      if @posting.save
        flash[:notice] = 'Posting was successfully created.'
        format.html { redirect_to(postings_url) }
        format.xml  { render :xml => @posting, :status => :created, :location => @posting }
        format.json { render :json => [] }
        format.js   { flash[:notice] = "Ny postering tilføjet" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
        format.json { render :json => [] }
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
        flash[:notice] = 'Posting was successfully updated.'
        format.html { redirect_to(@posting) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @posting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.xml
  def destroy
    @posting = current_user.postings.find(params[:id])
    @posting.destroy

    respond_to do |format|
      format.html { redirect_to(postings_url) }
      format.xml  { head :ok }
    end
  end
  
  def download
    @posting = current_user.postings.find(params[:id])
    
    redirect_to @posting.authenticated_url
  end
end
