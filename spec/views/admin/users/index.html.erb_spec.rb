require 'spec_helper'

describe "/admin_users/index.html.erb" do
  include Admin::UsersHelper

  before(:each) do
    assigns[:admin_users] = [
      stub_model(User),
      stub_model(User)
    ]
  end

  it "renders a list of admin_users" do
    render
  end
end
