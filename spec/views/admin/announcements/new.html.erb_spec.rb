require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin_announcements/new.html.erb" do
  include Admin::AnnouncementsHelper

  before(:each) do
    assigns[:announcement] = stub_model(Admin::Announcement,
      :new_record? => true,
      :title => "value for title",
      :message => "value for message"
    )
  end

  it "should render new form" do
    render "/admin_announcements/new.html.erb"

    response.should have_tag("form[action=?][method=post]", admin_announcements_path) do
      with_tag("input#announcement_title[name=?]", "announcement[title]")
      with_tag("textarea#announcement_message[name=?]", "announcement[message]")
    end
  end
end
