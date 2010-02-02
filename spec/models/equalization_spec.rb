require 'spec_helper'

describe Equalization do
  before(:each) do
    @valid_attributes = {
      :transaction_id => 1,
      :related_transaction_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Equalization.create!(@valid_attributes)
  end
end
