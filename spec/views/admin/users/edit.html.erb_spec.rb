require 'spec_helper'

describe "/admin_users/edit.html.erb" do
  include Admin::UsersHelper

  before(:each) do
    assigns[:user] = @user = stub_model(Admin::User,
      :new_record? => false
    )
  end

  it "renders the edit user form" do
    render

    response.should have_tag("form[action=#{user_path(@user)}][method=post]") do
    end
  end
end
