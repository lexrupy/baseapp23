require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin_announcements/index.html.erb" do
  include Admin::AnnouncementsHelper

  before(:each) do
    assigns[:admin_announcements] = [
      stub_model(Admin::Announcement,
        :title => "value for title",
        :message => "value for message"
      ),
      stub_model(Admin::Announcement,
        :title => "value for title",
        :message => "value for message"
      )
    ]
  end

  it "should render list of admin_announcements" do
    render "/admin_announcements/index.html.erb"
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for message".to_s, 2)
  end
end
