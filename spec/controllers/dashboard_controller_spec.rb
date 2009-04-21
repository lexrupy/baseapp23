require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardController do
  integrate_views

  describe "Global Links" do
    it "should show the current user name"
    it "should show a dashboard link"
    it "should show an administration link only for admin users"
    it "should show a logout link"
    it "should require an authenticated user for all actions"
  end


end

