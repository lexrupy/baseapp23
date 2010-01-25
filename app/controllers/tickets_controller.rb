class TicketsController < ApplicationController
  require_role :admin, :only => [:edit, :destroy]

  def index
    conditions = {}
    finder = params[:status].blank? ? Ticket : Ticket.scoped_by_status(params[:status])
    conditions = ["subject like ?", "%#{params[:query]}%"] unless params[:query].blank?
    @tickets = finder.paginate(:page => params[:page], :per_page => 10, :conditions => conditions, :order => 'created_at DESC')
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.creator = current_user
    if @ticket.save
      unless @ticket.assigned_email.nil?
        TicketMailer.deliver_create_ticket(@ticket)
      end
      flash[:notice] = t('tickets.create.flash.notice', :default => 'Ticket was successfully created.')
      redirect_to @ticket
    else
      render :action => "new"
    end
  end

  def update
    @ticket = Ticket.find(params[:id])
    if @ticket.update_attributes(params[:ticket])
      flash[:notice] = t('tickets.update.flash.notice', :default => 'Ticket was successfully updated.')
      redirect_to @ticket
    else
      render :action => "edit"
    end
  end

  def ticket_update
    @ticket = Ticket.find(params[:id])
    @ticket_update = TicketUpdate.new(params[:ticket_update])
    if (@ticket_update.body.blank? &&
        @ticket_update.status == @ticket.status &&
        @ticket_update.priority == @ticket.priority &&
        @ticket_update.category == @ticket.category &&
        @ticket_update.assigned_to_id.to_s == @ticket.assigned_to_id.to_s)
       render :action => "show"
    else
      @ticket_update.ticket = @ticket
      @ticket_update.user = current_user
      if @ticket_update.save
        TicketMailer.deliver_update_ticket(@ticket_update)
        flash[:notice] = t('tickets.ticket_update.flash.notice', :default => 'Ticket was successfully updated.')
        redirect_to @ticket
      else
        flash[:error] = t('tickets.ticket_update.flash.errors', :default => 'Fill all required fields.')
        render :action => "show"
      end
    end
  end

  def update_delete
    @ticket_update = TicketUpdate.find(params[:id])
    ticket = @ticket_update.ticket
    @ticket_update.destroy
    redirect_to ticket
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to tickets_url
  end
end

