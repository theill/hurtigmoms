class AboutController < ApplicationController
  def index
    render :layout => 'frontpage' unless signed_in?
  end
end