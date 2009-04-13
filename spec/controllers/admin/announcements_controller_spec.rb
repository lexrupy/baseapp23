require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AnnouncementsController do

  def mock_announcement(stubs={})
    @mock_announcement ||= mock_model(Admin::Announcement, stubs)
  end

  before :each do
    do_authorize
  end

  describe "responding to GET index" do

    it "should expose all admin_announcements as @admin_announcements" do
      Admin::Announcement.stubs(:paginate).returns([mock_announcement])
      get :index
      assigns[:announcements].should == [mock_announcement]
    end
  end

  describe "responding to GET show" do

    it "should expose the requested announcement as @announcement" do
      Admin::Announcement.stubs(:find).with("37").returns(mock_announcement)
      get :show, :id => "37"
      assigns[:announcement].should equal(mock_announcement)
    end
  end

  describe "responding to GET new" do

    it "should expose a new announcement as @announcement" do
      Admin::Announcement.stubs(:new).returns(mock_announcement)
      get :new
      assigns[:announcement].should equal(mock_announcement)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested announcement as @announcement" do
      Admin::Announcement.stubs(:find).with("37").returns(mock_announcement)
      get :edit, :id => "37"
      assigns[:announcement].should equal(mock_announcement)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created announcement as @announcement" do
        Admin::Announcement.stubs(:new).with({'these' => 'params'}).returns(mock_announcement(:save => true))
        post :create, :admin_announcement => {:these => 'params'}
        assigns(:announcement).should equal(mock_announcement)
      end

      it "should redirect to the created announcement" do
        Admin::Announcement.stubs(:new).returns(mock_announcement(:save => true))
        post :create, :announcement => {}
        response.should redirect_to(admin_announcement_url(mock_announcement))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved announcement as @announcement" do
        Admin::Announcement.stubs(:new).with({'these' => 'params'}).returns(mock_announcement(:save => false))
        post :create, :admin_announcement => {:these => 'params'}
        assigns(:announcement).should equal(mock_announcement)
      end

      it "should re-render the 'new' template" do
        Admin::Announcement.stubs(:new).returns(mock_announcement(:save => false))
        post :create, :admin_announcement => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested announcement" do
        Admin::Announcement.stubs(:find).with("37").returns(mock_announcement)
        mock_announcement.stubs(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :admin_announcement => {:these => 'params'}
      end

      it "should expose the requested announcement as @announcement" do
        Admin::Announcement.stubs(:find).returns(mock_announcement(:update_attributes => true))
        put :update, :id => "1"
        assigns(:announcement).should equal(mock_announcement)
      end

      it "should redirect to the announcement" do
        Admin::Announcement.stubs(:find).returns(mock_announcement(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(admin_announcement_url(mock_announcement))
      end

    end

    describe "with invalid params" do

      it "should update the requested announcement" do
        Admin::Announcement.stubs(:find).with("37").returns(mock_announcement)
        mock_announcement.stubs(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :admin_announcement => {:these => 'params'}
      end

      it "should expose the announcement as @announcement" do
        Admin::Announcement.stubs(:find).returns(mock_announcement(:update_attributes => false))
        put :update, :id => "1"
        assigns(:announcement).should equal(mock_announcement)
      end

      it "should re-render the 'edit' template" do
        Admin::Announcement.stubs(:find).returns(mock_announcement(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested announcement" do
      Admin::Announcement.stubs(:find).with("37").returns(mock_announcement)
      mock_announcement.stubs(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the admin_announcements list" do
      Admin::Announcement.stubs(:find).returns(mock_announcement(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_announcements_url)
    end

  end

end

