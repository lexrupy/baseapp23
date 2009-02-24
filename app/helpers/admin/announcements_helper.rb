module Admin::AnnouncementsHelper
  def announcement_form_path(ann)
    ann.new_record? ? admin_announcements_path : admin_announcement_path(ann)
  end
end
