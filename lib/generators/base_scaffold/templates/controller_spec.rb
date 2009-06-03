require File.expand_path(File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper')

describe <%= controller_class_name %>Controller do

  before(:each) do
    do_authorize
  end

  def mock_<%= file_name %>(stubs={})
    @mock_<%= file_name %> ||= mock_model(<%= class_name %>, stubs)
  end

  describe "GET index" do
    it "assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
      expects_paginate(<%= class_name %>, paginate_results(mock_<%= file_name %>))
      get :index
      assigns[:<%= table_name %>].should == [mock_<%= file_name %>]
    end
  end

  describe "GET show" do
    it "assigns the requested <%= file_name %> as @<%= file_name %>" do
      <%= class_name %>.expects(:find).with("37").returns(mock_<%= file_name %>)
      get :show, :id => "37"
      assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
    end
  end

  describe "GET new" do
    it "assigns a new <%= file_name %> as @<%= file_name %>" do
      <%= class_name %>.expects(:new).returns(mock_<%= file_name %>)
      get :new
      assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
    end
  end

  describe "GET edit" do
    it "assigns the requested <%= file_name %> as @<%= file_name %>" do
      <%= class_name %>.expects(:find).with("37").returns(mock_<%= file_name %>)
      get :edit, :id => "37"
      assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created <%= file_name %> as @<%= file_name %>" do
        <%= class_name %>.expects(:new).with({'these' => 'params'}).returns(mock_<%= file_name %>(:save => true))
        post :create, :<%= file_name %> => {:these => 'params'}
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "redirects to the created <%= file_name %>" do
        <%= class_name %>.stubs(:new).returns(mock_<%= file_name %>(:save => true))
        post :create, :<%= file_name %> => {}
        response.should redirect_to(<%= table_name.singularize %>_url(mock_<%= file_name %>))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved <%= file_name %> as @<%= file_name %>" do
        <%= class_name %>.stubs(:new).with({'these' => 'params'}).returns(mock_<%= file_name %>(:save => false))
        post :create, :<%= file_name %> => {:these => 'params'}
        assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
      end

      it "re-renders the 'new' template" do
        <%= class_name %>.stubs(:new).returns(mock_<%= file_name %>(:save => false))
        post :create, :<%= file_name %> => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested <%= file_name %>" do
        <%= class_name %>.expects(:find).with("37").returns(mock_<%= file_name %>)
        mock_<%= file_name %>.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :<%= file_name %> => {:these => 'params'}
      end

      it "assigns the requested <%= file_name %> as @<%= file_name %>" do
        <%= class_name %>.stubs(:find).returns(mock_<%= file_name %>(:update_attributes => true))
        put :update, :id => "1"
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "redirects to the <%= file_name %>" do
        <%= class_name %>.stubs(:find).returns(mock_<%= file_name %>(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(<%= table_name.singularize %>_url(mock_<%= file_name %>))
      end
    end

    describe "with invalid params" do
      it "updates the requested <%= file_name %>" do
        <%= class_name %>.expects(:find).with("37").returns(mock_<%= file_name %>)
        mock_<%= file_name %>.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :<%= file_name %> => {:these => 'params'}
      end

      it "assigns the <%= file_name %> as @<%= file_name %>" do
        <%= class_name %>.stubs(:find).returns(mock_<%= file_name %>(:update_attributes => false))
        put :update, :id => "1"
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "re-renders the 'edit' template" do
        <%= class_name %>.stubs(:find).returns(mock_<%= file_name %>(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested <%= file_name %>" do
      <%= class_name %>.expects(:find).with("37").returns(mock_<%= file_name %>)
      mock_<%= file_name %>.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the <%= table_name %> list" do
      <%= class_name %>.stubs(:find).returns(mock_<%= file_name %>(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(<%= table_name %>_url)
    end
  end

end

