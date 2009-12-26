class Setting < ActiveRecord::Base
  validates_presence_of :label
  validates_uniqueness_of :label
  validates_uniqueness_of :identifier

  # Store any kind of object in the value field.
  # This is nice, but you should also make it editable through admin/settings
  serialize :value

  def self.load(identifier)
    find_by_identifier(identifier.to_s)
  end

  # Return the value for a setting
  def self.get(identifier)
    begin
      setting = find_by_identifier(identifier.to_s)
    rescue
      setting = nil
    end
    setting.nil? ? "" : setting.value
  end
  
  def for_select
     select_titles.split('|').zip(select_options.split('|'))
  end
  
  
end
