class Role < ActiveRecord::Base
  #has_and_belongs_to_many :users
  has_and_belongs_to_many :resources
  attr_accessible :resource_ids, :name
end
