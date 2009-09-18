class AboutController < ApplicationController
  def index
    if signed_in?
      @action_required = current_user.postings.count(:all, :conditions => ['state = ?', Posting::STATES[:pending]]) > 0
    else
      render :layout => 'frontpage'
    end
  end
end