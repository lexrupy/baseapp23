require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/index.html.erb" do
  include ItemHelper

  before(:each) do
    assigns[:controller].stubs(:authorized?).returns(true)
    assigns[:items] = [
      stub_model(Items),
      stub_model(Items)
    ]
    assigns[:items].stubs(:page_count).returns(1)
  end

  it "renders a list of items" do
    render
  end
end

