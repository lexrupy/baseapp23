require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "/admin_announcements/edit.html.erb" do
  include Admin::AnnouncementsHelper

  before(:each) do
    assigns[:announcement] = @announcement = stub_model(Admin::Announcement,
      :new_record? => false,
      :title => "value for title",
      :message => "value for message"
    )
  end

  it "should render edit form" do
    render "/admin_announcements/edit.html.erb"

    response.should have_tag("form[action=#{announcement_path(@announcement)}][method=post]") do
      with_tag('input#announcement_title[name=?]', "announcement[title]")
      with_tag('textarea#announcement_message[name=?]', "announcement[message]")
    end
  end
end
