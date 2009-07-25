require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  before :each do
    do_authorize
  end

  describe "responding to GET index" do

    it "should expose all users as @users" do
      User.stubs(:paginate).returns([mock_user])
      get :index
      assigns[:users].should == [mock_user]
    end
  end

  describe "responding to GET show" do

    it "should expose the requested user as @user" do
      User.stubs(:find).with("37").returns(mock_user)
      get :show, :id => "37"
      assigns[:user].should equal(mock_user)
    end
  end

  describe "responding to GET new" do

    it "should expose a new user as @user" do
      User.stubs(:new).returns(mock_user)
      get :new
      assigns[:user].should equal(mock_user)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested user as @user" do
      User.stubs(:find).with("37").returns(mock_user)
      get :edit, :id => "37"
      assigns[:user].should equal(mock_user)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created user as @user" do
        User.stubs(:new).with({'these' => 'params'}).returns(mock_user(:register! => true))
        post :create, :user => {:these => 'params'}
        assigns(:user).should equal(mock_user)
      end

      it "should redirect to the created user" do
        User.stubs(:new).returns(mock_user(:register! => true))
        post :create, :user => {}
        response.should redirect_to(admin_user_url(mock_user))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved user as @user" do
        User.stubs(:new).with({'these' => 'params'}).returns(mock_user(:register! => true))
        post :create, :user => {:these => 'params'}
        assigns(:user).should equal(mock_user)
      end

      it "should re-render the 'new' template" do
        User.stubs(:new).returns(mock_user(:register! => false))
        post :create, :user => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    def stubs_user
      mcuser = mock_user(:save => true)
      mcuser.expects(:"role_ids=").with(['[1]'])
      mcuser.expects(:"resource_ids=").with(['[1]'])
      User.stubs(:find).returns(mcuser)
      mcuser
    end

    describe "with valid params" do

      it "should update the requested user" do
        stubs_user
        put :update, :id => 1, :user => {:role_ids => ['[1]'], :resource_ids => ['[1]']}
      end

      it "should expose the requested user as @user" do
        stubs_user
        put :update, :id => 1, :user => {:role_ids => ['[1]'], :resource_ids => ['[1]']}
        assigns(:user).should equal(mock_user)
      end

      it "should redirect to the user" do
        stubs_user
        put :update, :id => 1, :user => {:role_ids => ['[1]'], :resource_ids => ['[1]']}
        response.should redirect_to(admin_user_url(mock_user))
      end

    end

    describe "with invalid params" do

      it "should re-render the 'edit' template" do
        stubs_user.stubs(:save).returns(false)
        put :update, :id => 1, :user => {:role_ids => ['[1]'], :resource_ids => ['[1]']}
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested user" do
      User.stubs(:find).with("37").returns(mock_user)
      mock_user.stubs(:delete!)
      delete :destroy, :id => "37"
    end

    it "should redirect to the users list" do
      User.stubs(:find).returns(mock_user(:delete! => true))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_users_url)
    end

  end

end

