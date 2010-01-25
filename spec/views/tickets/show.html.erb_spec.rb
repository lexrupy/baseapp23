require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/show.html.erb" do
  include TicketsHelper
  before(:each) do
    assigns[:ticket] = @ticket = stub_model(Ticket)
  end

  it "renders attributes in <p>" do
    render
  end
end

