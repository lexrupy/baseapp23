require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TicketsController do

  def mock_ticket(stubs={})
    @mock_ticket ||= mock_model(Ticket, stubs) do |m|
      m.stubs :'creator=' => true, :assigned_email => nil
    end
  end

  before :each do
    do_authorize
  end

  describe "responding to GET index" do

    it "should expose all tickets as @tickets" do
      Ticket.stubs(:paginate).returns([mock_ticket])
      get :index
      assigns[:tickets].should == [mock_ticket]
    end
  end

  describe "responding to GET show" do

    it "should expose the requested ticket as @ticket" do
      Ticket.stubs(:find).with('37').returns(mock_ticket)
      get :show, :id => "37"
      assigns[:ticket].should equal(mock_ticket)
    end
  end

  describe "responding to GET new" do

    it "should expose a new ticket as @ticket" do
      Ticket.stubs(:new).returns(mock_ticket)
      get :new
      assigns[:ticket].should equal(mock_ticket)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested ticket as @ticket" do
      Ticket.stubs(:find).with("37").returns(mock_ticket)
      get :edit, :id => "37"
      assigns[:ticket].should equal(mock_ticket)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created ticket as @ticket" do
        Ticket.stubs(:new).with({'these' => 'params'}).returns(mock_ticket(:save => true))
        post :create, :ticket => {:these => 'params'}
        assigns(:ticket).should equal(mock_ticket)
      end

      it "should redirect to the created ticket" do
        Ticket.stubs(:new).returns(mock_ticket(:save => true))
        post :create, :ticket => {}
        response.should redirect_to(ticket_url(mock_ticket))
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved ticket as @ticket" do
        Ticket.stubs(:new).with({'these' => 'params'}).returns(mock_ticket(:save => false))
        post :create, :ticket => {:these => 'params'}
        assigns(:ticket).should equal(mock_ticket)
      end

      it "should re-render the 'new' template" do
        Ticket.stubs(:new).returns(mock_ticket(:save => false))
        post :create, :ticket => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested ticket" do
        Ticket.stubs(:find).with("37").returns(mock_ticket)
        mock_ticket.stubs(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ticket => {:these => 'params'}
      end

      it "should expose the requested ticket as @ticket" do
        Ticket.stubs(:find).returns(mock_ticket(:update_attributes => true))
        put :update, :id => "1"
        assigns(:ticket).should equal(mock_ticket)
      end

      it "should redirect to the ticket" do
        Ticket.stubs(:find).returns(mock_ticket(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(ticket_url(mock_ticket))
      end

    end

    describe "with invalid params" do

      it "should update the requested ticket" do
        Ticket.stubs(:find).with("37").returns(mock_ticket)
        mock_ticket.stubs(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ticket => {:these => 'params'}
      end

      it "should expose the ticket as @ticket" do
        Ticket.stubs(:find).returns(mock_ticket(:update_attributes => false))
        put :update, :id => "1"
        assigns(:ticket).should equal(mock_ticket)
      end

      it "should re-render the 'edit' template" do
        Ticket.stubs(:find).returns(mock_ticket(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested ticket" do
      Ticket.stubs(:find).with("37").returns(mock_ticket)
      mock_ticket.stubs(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the tickets list" do
      Ticket.stubs(:find).returns(mock_ticket(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(tickets_url)
    end

  end

end

