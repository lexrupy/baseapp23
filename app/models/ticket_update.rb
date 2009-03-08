class TicketUpdate < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  belongs_to :ticket
  belongs_to :user, :include => true # Eagerload
  belongs_to :assigned_to, :class_name => "User"
  attr_accessor :status, :category, :priority, :assigned_to_id
  before_create :adjust_data
  after_create :update_ticket

  def user_change
    user.nil? ? "" : user.login
  end

  private

  def adjust_data
    if ticket.assigned_to_id != assigned_to_id
      unless assigned_to_id.blank?
        u = User.find(assigned_to_id)
        user_name = u.login
      else
        user_name = "Unassigned"
      end
      if ticket.assigned_to.nil?
        self.assigned_change = "#{user_name}" unless u.nil?
      else
        self.assigned_change = "#{ticket.assigned_to.login} => #{user_name}" unless u.nil?
      end
    end
    if ticket.status != status && !status.blank?
      self.status_change = "#{ticket.status} => #{status}"
    end
    if ticket.category != category && !category.blank?
      self.category_change = "#{ticket.category} => #{category}"
    end
    if ticket.priority != priority && !priority.blank?
      self.priority_change = "#{ticket.priority} => #{priority}"
    end
  end

  def update_ticket
    attrs = {}
    attrs.merge!(:assigned_to_id => assigned_to_id)
    attrs.merge!(:category => category) unless category.blank?
    attrs.merge!(:status => status) unless status.blank?
    attrs.merge!(:priority => priority) unless priority.blank?
    ticket.update_attributes(attrs)
  end
end

