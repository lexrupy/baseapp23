require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::Announcement do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :message => "value for message",
      :starts_at => Time.now,
      :ends_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Admin::Announcement.create!(@valid_attributes)
  end
end
