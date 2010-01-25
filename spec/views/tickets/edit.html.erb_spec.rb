require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/edit.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:ticket] = @ticket = stub_model(Ticket,
      :new_record? => false
    )
  end

  it "renders the edit ticket form" do
    render

    response.should have_tag("form[action=#{ticket_path(@ticket)}][method=post]") do
    end
  end
end

