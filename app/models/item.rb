class Item < ActiveRecord::Base

  TYPES = %w(computer monitor printer network)
  ROLES = %w(workstation server print-server)
  STATUSES = %w(active inactive damaged maintenance)

  [:item_model, :location, :video, :manufacturer, :user, :operating_system,
  :processor, :display, :supplier].each do |field|

    attr_accessor :"#{field}_new"

    define_method :"#{field}_new=" do |value|
      unless value.blank?
        klass = "Item#{field.to_s.gsub('item_','').camelize}"
        eval "#{klass}.find_or_create_by_name_and_item_type(value, self.item_type)"
        self.send :"#{field}=", value
      end
    end

  end

  [:type, :status, :role].each do |field|

    define_method :"#{field}_name" do |value|
      attr_name = value || self.send(:"item_#{field}")
      self.class.human_attribute_name("#{field}_names.#{attr_name}")
    end

    define_method :"#{field.to_s.pluralize}_for_select" do
      returning [] do |values|
        eval %Q{
        Item::#{field.to_s.pluralize.upcase}.each do |vl|
          values << [self.#{field}_name(vl), vl]
        end
        }
      end
    end
  end

  [:computer, :printer, :network].each do |field|
    define_method :"#{field}?" do
      self.item_type == field.to_s
    end
  end

end

