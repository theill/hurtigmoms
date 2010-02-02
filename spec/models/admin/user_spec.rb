require 'spec_helper'

describe Admin::User do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Admin::User.create!(@valid_attributes)
  end
end
