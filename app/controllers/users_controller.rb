class UsersController < Clearance::UsersController
  before_filter :authenticate, :only => :edit
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = I18n.t('user.updated.success')
        format.html { redirect_to(settings_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
    
end
