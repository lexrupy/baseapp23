class Resource < ActiveRecord::Base
  belongs_to :resource_group
  delegate :name, :to => :resource_group, :prefix => true, :allow_nil => true
end
