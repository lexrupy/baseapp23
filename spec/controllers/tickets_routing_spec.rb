require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TicketsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "tickets", :action => "index").should == "/tickets"
    end

    it "should map #new" do
      route_for(:controller => "tickets", :action => "new").should == "/tickets/new"
    end

    it "should map #show" do
      route_for(:controller => "tickets", :action => "show", :id => 1).should == "/tickets/1"
    end

    it "should map #edit" do
      route_for(:controller => "tickets", :action => "edit", :id => 1).should == "/tickets/1/edit"
    end

    it "should map #update" do
      route_for(:controller => "tickets", :action => "update", :id => 1).should == "/tickets/1"
    end

    it "should map #destroy" do
      route_for(:controller => "tickets", :action => "destroy", :id => 1).should == "/tickets/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/tickets").should == {:controller => "tickets", :action => "index"}
    end

    it "should generate params for #new" do
      params_from(:get, "/tickets/new").should == {:controller => "tickets", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/tickets").should == {:controller => "tickets", :action => "create"}
    end

    it "should generate params for #show" do
      params_from(:get, "/tickets/1").should == {:controller => "tickets", :action => "show", :id => "1"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/tickets/1/edit").should == {:controller => "tickets", :action => "edit", :id => "1"}
    end

    it "should generate params for #update" do
      params_from(:put, "/tickets/1").should == {:controller => "tickets", :action => "update", :id => "1"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/tickets/1").should == {:controller => "tickets", :action => "destroy", :id => "1"}
    end
  end
end
