require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:tickets] = [
      stub_model(Ticket,
        :creator_id => 1,
        :assigned_to_id => 1,
        :subject => "value for subject",
        :body => "value for body",
        :category => "value for category",
        :status => "value for status",
        :priority => "value for priority"
      ),
      stub_model(Ticket,
        :creator_id => 1,
        :assigned_to_id => 1,
        :subject => "value for subject",
        :body => "value for body",
        :category => "value for category",
        :status => "value for status",
        :priority => "value for priority"
      )
    ]
  end

  it "should render list of tickets" do
    render "/tickets/index.html.erb"
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for subject".to_s, 2)
    response.should have_tag("tr>td", "value for body".to_s, 2)
    response.should have_tag("tr>td", "value for category".to_s, 2)
    response.should have_tag("tr>td", "value for status".to_s, 2)
    response.should have_tag("tr>td", "value for priority".to_s, 2)
  end
end
