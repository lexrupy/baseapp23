require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TicketUpdate do
  before(:each) do
    @valid_attributes = {
      :ticket => ,
      :user => ,
      :status_change => "value for status_change",
      :category_change => "value for category_change",
      :priority_change => "value for priority_change",
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    TicketUpdate.create!(@valid_attributes)
  end
end
