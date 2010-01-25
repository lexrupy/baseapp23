require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemController do

  before(:each) do
    do_authorize
  end

  def mock_items(stubs={})
    @mock_items ||= mock_model(Items, stubs)
  end

  describe "GET index" do
    it "assigns all items as @items" do
      expects_paginate(Items, paginate_results(mock_items))
      get :index
      assigns[:items].should == [mock_items]
    end
  end

  describe "GET show" do
    it "assigns the requested items as @items" do
      Items.expects(:find).with("37").returns(mock_items)
      get :show, :id => "37"
      assigns[:items].should equal(mock_items)
    end
  end

  describe "GET new" do
    it "assigns a new items as @items" do
      Items.expects(:new).returns(mock_items)
      get :new
      assigns[:items].should equal(mock_items)
    end
  end

  describe "GET edit" do
    it "assigns the requested items as @items" do
      Items.expects(:find).with("37").returns(mock_items)
      get :edit, :id => "37"
      assigns[:items].should equal(mock_items)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created items as @items" do
        Items.expects(:new).with({'these' => 'params'}).returns(mock_items(:save => true))
        post :create, :items => {:these => 'params'}
        assigns(:items).should equal(mock_items)
      end

      it "redirects to the created items" do
        Items.stubs(:new).returns(mock_items(:save => true))
        post :create, :items => {}
        response.should redirect_to(item_url(mock_items))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved items as @items" do
        Items.stubs(:new).with({'these' => 'params'}).returns(mock_items(:save => false))
        post :create, :items => {:these => 'params'}
        assigns[:items].should equal(mock_items)
      end

      it "re-renders the 'new' template" do
        Items.stubs(:new).returns(mock_items(:save => false))
        post :create, :items => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested items" do
        Items.expects(:find).with("37").returns(mock_items)
        mock_items.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :items => {:these => 'params'}
      end

      it "assigns the requested items as @items" do
        Items.stubs(:find).returns(mock_items(:update_attributes => true))
        put :update, :id => "1"
        assigns(:items).should equal(mock_items)
      end

      it "redirects to the items" do
        Items.stubs(:find).returns(mock_items(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(item_url(mock_items))
      end
    end

    describe "with invalid params" do
      it "updates the requested items" do
        Items.expects(:find).with("37").returns(mock_items)
        mock_items.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :items => {:these => 'params'}
      end

      it "assigns the items as @items" do
        Items.stubs(:find).returns(mock_items(:update_attributes => false))
        put :update, :id => "1"
        assigns(:items).should equal(mock_items)
      end

      it "re-renders the 'edit' template" do
        Items.stubs(:find).returns(mock_items(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested items" do
      Items.expects(:find).with("37").returns(mock_items)
      mock_items.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the items list" do
      Items.stubs(:find).returns(mock_items(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(items_url)
    end
  end

end

