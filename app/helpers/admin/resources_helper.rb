module Admin::ResourcesHelper
  def resource_form_path(res)
    res.new_record? ? admin_resources_path : admin_resource_path(res)
  end
end
