require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/new.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:ticket] = stub_model(Ticket,
      :new_record? => true
    )
  end

  it "renders new ticket form" do
    render

    response.should have_tag("form[action=?][method=post]", tickets_path) do
    end
  end
end

