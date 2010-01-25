require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/show.html.erb" do
  include ItemHelper
  before(:each) do
    assigns[:items] = @items = stub_model(Items)
  end

  it "renders attributes in <p>" do
    render
  end
end

