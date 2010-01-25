class ItemUser < ActiveRecord::Base

  def self.for_select(eq_type=nil, eq_location=nil)
    cond = {:item_type => eq_type} unless eq_type.blank?
    cond.merge!({:location => eq_location}) unless eq_location.blank?
    all(:conditions => cond).map { |obj| [obj.name, obj.name]}
  end

end

