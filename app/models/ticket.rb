class Ticket < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  belongs_to :assigned_to, :class_name => "User"
  has_many :ticket_updates
  has_and_belongs_to_many :users
  CATEGORIES      = %w(defect improvement)
  PRIORITIES      = %w(low normal high)
  STATUS          = %w(open accepted resolved canceled reopened)

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
        values << [self.status_name(s), s]
      end
    end
    values
  end

  def categories_for_select
    returning [] do |values|
      Ticket::CATEGORIES.each do |cat|
        values << [self.category_name(cat), cat]
      end
    end
  end

  def priorities_for_select
    returning [] do |values|
      Ticket::PRIORITIES.each do |cat|
        values << [self.priority_name(cat), cat]
      end
    end
  end

  def assigned_email
    if assigned_to.nil? || assigned_to.email.blank?
      return nil
    end
    assigned_to.profile.notify_ticket_update ? assigned_to.email : nil
  end

  def watching_emails
    emails = self.users.all(
      :include => :profile,
      :conditions => ['profiles.notify_ticket_update = ?', true]).collect(&:email)
    emails.compact
  end

  def status_name(status=nil)
    self.class.human_attribute_name("status_names.#{status || self.status}")
  end

  def priority_name(priority=nil)
    self.class.human_attribute_name("priority_names.#{priority || self.priority}")
  end

  def category_name(category=nil)
    self.class.human_attribute_name("category_names.#{category || self.category}")
  end
end

