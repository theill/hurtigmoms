class AboutController < ApplicationController
  def index
    if signed_in?
      @action_required = current_user.active_fiscal_year.transactions.incomplete.count > 0
    else
      render :layout => 'frontpage'
    end
  end
end