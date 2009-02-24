require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/show.html.erb" do
  include TicketsHelper
  before(:each) do
    assigns[:ticket] = @ticket = stub_model(Ticket,
      :creator_id => 1,
      :assigned_to_id => 1,
      :subject => "value for subject",
      :body => "value for body",
      :category => "value for category",
      :status => "value for status",
      :priority => "value for priority"
    )
  end

  it "should render attributes in <p>" do
    render "/tickets/show.html.erb"
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ subject/)
    response.should have_text(/value\ for\ body/)
    response.should have_text(/value\ for\ category/)
    response.should have_text(/value\ for\ status/)
    response.should have_text(/value\ for\ priority/)
  end
end
