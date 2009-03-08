class TicketMailer < ActionMailer::Base

  def create_ticket(ticket)
    setup_email
    subject       "[#{configatron.site_name}] Ticket #{ticket.ticket_id} created"
    recipients    ticket.assigned_email
    body          :ticket => ticket
  end

  def update_ticket(ticket_update)
    setup_email
    subject       "[#{configatron.site_name}] Ticket #{ticket_update.ticket.ticket_id} updated"
    recipients    ticket_update.ticket.watching_emails
    body          :ticket_update => ticket_update
  end

  protected

  def setup_email
    from          configatron.ticket_email
    content_type  "text/html"
    sent_on       Time.now
  end

end

