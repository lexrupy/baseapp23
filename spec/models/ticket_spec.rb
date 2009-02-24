require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Ticket do
  before(:each) do
    @valid_attributes = {
      :creator_id => 1,
      :assigned_to_id => 1,
      :subject => "value for subject",
      :body => "value for body",
      :category => "value for category",
      :status => "value for status",
      :priority => "value for priority"
    }
  end

  it "should create a new instance given valid attributes" do
    Ticket.create!(@valid_attributes)
  end
end
