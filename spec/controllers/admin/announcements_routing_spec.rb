require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::AnnouncementsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "admin_announcements", :action => "index").should == "/admin_announcements"
    end

    it "should map #new" do
      route_for(:controller => "admin_announcements", :action => "new").should == "/admin_announcements/new"
    end

    it "should map #show" do
      route_for(:controller => "admin_announcements", :action => "show", :id => 1).should == "/admin_announcements/1"
    end

    it "should map #edit" do
      route_for(:controller => "admin_announcements", :action => "edit", :id => 1).should == "/admin_announcements/1/edit"
    end

    it "should map #update" do
      route_for(:controller => "admin_announcements", :action => "update", :id => 1).should == "/admin_announcements/1"
    end

    it "should map #destroy" do
      route_for(:controller => "admin_announcements", :action => "destroy", :id => 1).should == "/admin_announcements/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/admin_announcements").should == {:controller => "admin_announcements", :action => "index"}
    end

    it "should generate params for #new" do
      params_from(:get, "/admin_announcements/new").should == {:controller => "admin_announcements", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/admin_announcements").should == {:controller => "admin_announcements", :action => "create"}
    end

    it "should generate params for #show" do
      params_from(:get, "/admin_announcements/1").should == {:controller => "admin_announcements", :action => "show", :id => "1"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/admin_announcements/1/edit").should == {:controller => "admin_announcements", :action => "edit", :id => "1"}
    end

    it "should generate params for #update" do
      params_from(:put, "/admin_announcements/1").should == {:controller => "admin_announcements", :action => "update", :id => "1"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/admin_announcements/1").should == {:controller => "admin_announcements", :action => "destroy", :id => "1"}
    end
  end
end
