require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/edit.html.erb" do
  include ItemHelper

  before(:each) do
    assigns[:items] = @items = stub_model(Items,
      :new_record? => false
    )
  end

  it "renders the edit item form" do
    render

    response.should have_tag("form[action=#{items_path(@items)}][method=post]") do
    end
  end
end

