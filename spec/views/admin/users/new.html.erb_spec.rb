require 'spec_helper'

describe "/admin_users/new.html.erb" do
  include Admin::UsersHelper

  before(:each) do
    assigns[:user] = stub_model(User,
      :new_record? => true
    )
  end

  it "renders new user form" do
    render

    response.should have_tag("form[action=?][method=post]", admin_users_path) do
    end
  end
end
