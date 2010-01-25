module TicketsHelper
  def status_style(ticket)
    return '' if ticket.nil?
    styles = {
      'open'       => "color:#1e90ff",
      'accepted'   => "color:#5ab75a",
      'resolved'   => "color:#ffc253",
      'canceled'   => "color:#ff0000",
      'reopened'   => "color:#a020f0",
      'duplicated' => "color:#ff0000;text-decoration:line-through"
    }
    styles[ticket.status]
  end
end

