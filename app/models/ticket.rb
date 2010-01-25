class Ticket < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :creator, :class_name => "User"
  belongs_to :assigned_to, :class_name => "User"
  has_many :ticket_updates
  has_and_belongs_to_many :users

  before_create :set_properties

  CATEGORIES      = %w(defect improvement)
  PRIORITIES      = %w(low normal high)
  STATUS          = %w(open accepted resolved canceled reopened duplicated)

  def ticket_id
    "##{id.to_s.rjust(5,'0')}"
  end

  def new_update
    ticket_updates.build(:category => self.category, :status => self.status, :priority => self.priority, :assigned_to_id => self.assigned_to_id)
  end

  def status_for_select
    values = []
    current = status || 'new'
    valid_status = {
      'new'        => ['open', 'duplicated'],
      'open'       => ['accepted', 'resolved', 'canceled', 'duplicated'],
      'accepted'   => ['resolved', 'canceled', 'duplicated'],
      'resolved'   => ['reopened'],
      'canceled'   => ['reopened'],
      'reopened'   => ['resolved', 'canceled', 'duplicated'],
      'duplicated' => ['accepted', 'resolved', 'canceled', 'reopened']
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

  def not_updated_yet?
    self.created_at == self.updated_at
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

  # Returns the body text of ticked properly formatted
  def formatted_body(no_paragraph = false)
    Formatter::TextFormatter.format(body, {:engine => (markup_engine || 'simple'), :no_paragraph => no_paragraph})
  end

  private

  def set_properties
    markup_engine = Setting.get('markup_engine')
  end

end

