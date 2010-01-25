require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/new.html.erb" do
  include ItemHelper

  before(:each) do
    assigns[:items] = stub_model(Items,
      :new_record? => true
    )
  end

  it "renders new item form" do
    render

    response.should have_tag("form[action=?][method=post]", items_path) do
    end
  end
end

