require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::RolesController do

  def mock_role(stubs={})
    @mock_role ||= mock_model(Role, stubs)
  end

  before :each do
    do_authorize
  end

  describe "responding to GET index" do

    it "should expose all roles as @roles" do
      Role.stubs(:paginate).returns([mock_role])
      get :index
      assigns[:roles].should == [mock_role]
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested role as @role" do
      Role.stubs(:find).with("37").returns(mock_role)
      get :edit, :id => "37"
      assigns[:role].should equal(mock_role)
    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested role" do
        Role.stubs(:find).with("37").returns(mock_role)
        mock_role.expects(:update_attributes).with({'these' => 'params', 'resource_ids' => []})
        put :update, :id => "37", :role => {:these => 'params'}
      end

      it "should expose the requested role as @role" do
        Role.stubs(:find).returns(mock_role(:update_attributes => true))
        put :update, :id => "1"
        assigns(:role).should equal(mock_role)
      end

      it "should redirect to the role" do
        Role.stubs(:find).returns(mock_role(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(admin_roles_path)
      end

    end

    describe "with invalid params" do

      it "should update the requested role" do
        Role.stubs(:find).with("37").returns(mock_role)
        mock_role.stubs(:update_attributes).with({'these' => 'params', 'resource_ids' => []})
        put :update, :id => "37", :role => {:these => 'params'}
      end

      it "should expose the role as @role" do
        Role.stubs(:find).returns(mock_role(:update_attributes => false))
        put :update, :id => "1"
        assigns(:role).should equal(mock_role)
      end

      it "should re-render the 'edit' template" do
        Role.stubs(:find).returns(mock_role(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

end

