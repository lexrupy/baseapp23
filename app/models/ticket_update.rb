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
        self.assigned_change = "Ticket assigned to <strong>#{user_name}</strong>" unless u.nil?
      else
        self.assigned_change = "Ticket reassigned from <strong>#{ticket.assigned_to.login}</strong> to <strong>#{user_name}</strong>" unless u.nil?
      end
    end
    if ticket.status != status && !status.blank?
      self.status_change = "Status changed from <strong>#{ticket.status}</strong> to <strong>#{status}</strong>"
    end
    if ticket.category != category && !category.blank?
      self.category_change = "Category changed from <strong>#{ticket.category}</strong> to <strong>#{category}</strong>"
    end
    if ticket.priority != priority && !priority.blank?
      self.priority_change = "Priority changed from <strong>#{ticket.priority}</strong> to <strong>#{priority}</strong>"
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
