class Ticket < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :assigned_to, :class_name => "User"
  has_many :ticket_updates
  CATEGORIES      = %w(defect improvement)
  CATEGORY_NAMES  = %w(Defect Improvement)
  PRIORITIES      = %w(low normal high)
  PRIORITY_NAMES  = %w(Low Normal High)
  STATUS          = %w(open accepted resolved canceled reopened)
  STATUS_NAMES    = %w(Open Accepted Resolved Canceled Reopened)

  def ticket_id
    "##{id.to_s.rjust(5,'0')}"
  end

  def new_update
    ticket_updates.build(:category => self.category, :status => self.status, :priority => self.priority)
  end

  def status_for_select
    values = []
    current = status || 'new'
    valid_status = {
      'new'     => ['open'],
      'open'    => ['accepted', 'resolved', 'canceled'],
      'accepted'=> ['resolved', 'canceled'],
      'resolved'=> ['reopened'],
      'canceled'=> ['reopened'],
      'reopened'=> ['resolved', 'canceled']
    }
    Ticket::STATUS.each_with_index do |s, i|
      if valid_status[current].include?(s) || s == current
        values << [Ticket::STATUS_NAMES[i], s]
      end
    end
    values
  end

  def status_name
    Ticket::STATUS_NAMES[Ticket::STATUS.index(status)]
  end

  def priority_name
    Ticket::PRIORITY_NAMES[Ticket::PRIORITIES.index(priority)]
  end

  def category_name
    Ticket::CATEGORY_NAMES[Ticket::CATEGORIES.index(category)]
  end
end
