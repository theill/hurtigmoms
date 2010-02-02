require 'spec_helper'

describe "/admin_users/show.html.erb" do
  include Admin::UsersHelper
  before(:each) do
    assigns[:user] = @user = stub_model(User)
  end

  it "renders attributes in <p>" do
    render
  end
end
