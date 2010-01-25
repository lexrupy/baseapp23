require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:controller].stubs(:authorized?).returns(true)
    assigns[:tickets] = [
      stub_model(Ticket),
      stub_model(Ticket)
    ]
    assigns[:tickets].stubs(:page_count).returns(1)
  end

  it "renders a list of tickets" do
    render
  end
end

