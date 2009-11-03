class AboutController < ApplicationController
  def index
    if signed_in?
      @action_required = current_user.active_fiscal_year.transactions.count(:all, :joins => [:account], :conditions => 'accounts.account_no = 9') > 0
    else
      render :layout => 'frontpage'
    end
  end
end