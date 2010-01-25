class ItemProcessor < ActiveRecord::Base

  def self.for_select(eq_type=nil)
    cond = {:item_type => eq_type} unless eq_type.nil?
    all(:conditions => cond).map { |obj| [obj.name, obj.name]}
  end

end

