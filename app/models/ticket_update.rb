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

  def self.updateable_attributes
    ['assigned_change', 'status_change', 'category_change', 'priority_change']
  end

  def attribute_updated?
    TicketUpdate.updateable_attributes.any? { |attrib| ! self[attrib.to_sym].blank?  }
  end

  ['status', 'category', 'priority'].each do |attribute|
    define_method("#{attribute}_change") do
      unless self["#{attribute}_change".to_sym].blank?
        old_value, new_value = self["#{attribute}_change".to_sym].split(' => ')
        changed_from = self.class.human_attribute_name('changed_from', :default => 'changed from')
        old_value = Ticket.human_attribute_name("#{attribute}_names.#{old_value}", :default => old_value)
        new_value = Ticket.human_attribute_name("#{attribute}_names.#{new_value}", :default => new_value)
        to = self.class.human_attribute_name('to', :default => 'to')
        "#{changed_from} _#{old_value}_ #{to} _#{new_value}_"
      end
    end
  end

  def assigned_change
    unless self[:assigned_change].blank?
      old_value, new_value = self[:assigned_change].split(' => ')
      changed_from = self.class.human_attribute_name('changed_from', :default => 'changed from')
      to = self.class.human_attribute_name('to', :default => 'to')
      if new_value.nil?
        "#{to} _#{old_value}_"
      else
        "#{changed_from} _#{old_value}_ #{to} _#{new_value}_"
      end
    end
  end

  private

  def adjust_data
    if ticket.assigned_to_id != assigned_to_id
      unless assigned_to_id.blank?
        u = User.find(assigned_to_id)
        user_name = u.display_name
      else
        user_name = self.class.human_attribute_name("unassigned", :default => "Unassigned")
      end
      if ticket.assigned_to.nil?
        self.assigned_change = "#{user_name}" unless u.nil?
      else
        self.assigned_change = "#{ticket.assigned_to.display_name} => #{user_name}" unless u.nil? || (u.id == ticket.assigned_to_id)
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

