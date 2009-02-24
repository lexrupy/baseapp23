require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin_announcements/show.html.erb" do
  include Admin::AnnouncementsHelper
  before(:each) do
    assigns[:announcement] = @announcement = stub_model(Admin::Announcement,
      :title => "value for title",
      :message => "value for message"
    )
  end

  it "should render attributes in <p>" do
    render "/admin_announcements/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ message/)
  end
end
