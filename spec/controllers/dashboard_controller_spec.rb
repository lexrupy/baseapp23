require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do

  describe "Aplication controller tests" do

    before :each do
      do_login
    end

    it "should default expiry to 10 minutes when expiry time is not set" do
      time = 10.minutes.from_now
      minute = mock('Minute') { |m| m.stubs(:from_now).returns(time) }
      Fixnum.any_instance.stubs(:minutes).returns(minute)
      get :index
      session[:expires_at].should == time
    end

    it "should update expiry time on each request" do
      get :index
      time = session[:expires_at]
      get :index
      session[:expires_at].should > time
    end

    it "should expire the user session after inactivity time"

    it "should require authenticated user for all actions"
  end

  describe "Global Links" do

    it "should show the current user name"

    it "should show a dashboard link"

    it "should show an administration link only for admin users"

    it "should show a logout link"

    it "should require an authenticated user for all actions"

  end


end

