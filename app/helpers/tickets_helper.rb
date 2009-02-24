module TicketsHelper
  def status_style(ticket)
    return '' if ticket.nil?
    styles = {
      'open'    => "color:#1e90ff",
      'accepted'=> "color:#5ab75a",
      'resolved'=> "color:#ffc253",
      'canceled'=> "color:#ff0000",
      'reopened'=> "color:#a020f0"
    }
    styles[ticket.status]
  end
end
