require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TicketsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "tickets", :action => "index").should == "/tickets"
    end

    it "maps #new" do
      route_for(:controller => "tickets", :action => "new").should == "/tickets/new"
    end

    it "maps #show" do
      route_for(:controller => "tickets", :action => "show", :id => "1").should == "/tickets/1"
    end

    it "maps #edit" do
      route_for(:controller => "tickets", :action => "edit", :id => "1").should == "/tickets/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "tickets", :action => "create").should == {:path => "/tickets", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "tickets", :action => "update", :id => "1").should == {:path =>"/tickets/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "tickets", :action => "destroy", :id => "1").should == {:path =>"/tickets/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/tickets").should == {:controller => "tickets", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/tickets/new").should == {:controller => "tickets", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/tickets").should == {:controller => "tickets", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/tickets/1").should == {:controller => "tickets", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/tickets/1/edit").should == {:controller => "tickets", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/tickets/1").should == {:controller => "tickets", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/tickets/1").should == {:controller => "tickets", :action => "destroy", :id => "1"}
    end
  end
end

