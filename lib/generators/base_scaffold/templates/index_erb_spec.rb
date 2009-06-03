require File.expand_path(File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../../spec_helper')

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "/<%= table_name %>/index.html.erb" do
  include <%= controller_class_name %>Helper

  before(:each) do
    assigns[:controller].stubs(:authorized?).returns(true)
    assigns[:<%= table_name %>] = [
<% [1,2].each_with_index do |id, model_index| -%>
      stub_model(<%= class_name %><%= output_attributes.empty? ? (model_index == 1 ? ')' : '),') : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
        :<%= attribute.name %> => <%= attribute.default_value %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
      <%= model_index == 1 ? ')' : '),' %>
<% end -%>
<% end -%>
    ]
    assigns[:<%= table_name %>].stubs(:page_count).returns(1)
  end

  it "renders a list of <%= table_name %>" do
    render
<% for attribute in output_attributes -%>
    response.should have_tag("tr>td", <%= attribute.default_value %>.to_s, 2)
<% end -%>
  end
end

