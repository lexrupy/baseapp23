require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/tickets/edit.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:ticket] = @ticket = stub_model(Ticket,
      :new_record? => false,
      :creator_id => 1,
      :assigned_to_id => 1,
      :subject => "value for subject",
      :body => "value for body",
      :category => "value for category",
      :status => "value for status",
      :priority => "value for priority"
    )
  end

  it "should render edit form" do
    render "/tickets/edit.html.erb"

    response.should have_tag("form[action=#{ticket_path(@ticket)}][method=post]") do
      with_tag('input#ticket_creator_id[name=?]', "ticket[creator_id]")
      with_tag('input#ticket_assigned_to_id[name=?]', "ticket[assigned_to_id]")
      with_tag('input#ticket_subject[name=?]', "ticket[subject]")
      with_tag('textarea#ticket_body[name=?]', "ticket[body]")
      with_tag('input#ticket_category[name=?]', "ticket[category]")
      with_tag('input#ticket_status[name=?]', "ticket[status]")
      with_tag('input#ticket_priority[name=?]', "ticket[priority]")
    end
  end
end
