require 'spec_helper'

describe ResourceGroup do
  before(:each) do
    @valid_attributes = {
      :name => 'group'
    }
  end

  it "should create a new instance given valid attributes" do
    ResourceGroup.create!(@valid_attributes)
  end
end
