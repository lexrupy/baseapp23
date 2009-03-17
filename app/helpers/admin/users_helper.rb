module Admin::UsersHelper

  def role_list(user)
    roles = user.roles.collect{ |r| r.name.humanize }
    roles.join " | "
  end

  def link_to_suspend_user(user)
    link_to_action(:suspend, suspend_admin_user_url(user), :text => 'Suspend',
      :method => :put) if ['pending', 'passive', 'active'].include?(user.state)
  end

  def link_to_unsuspend_user(user)
    link_to_action(:yes, unsuspend_admin_user_url(user), :text => 'Unsuspend',
      :method => :put) if user.suspended?
  end

  def link_to_activate_user(user)
    link_to_action(:yes, activate_admin_user_url(user), :text => 'Activate',
      :method => :put) if ['pending', 'passive'].include?(user.state)
  end

  def link_to_delete_user(user)
    link_to_destroy(admin_user_url(user)) unless user.deleted?
  end

  def link_to_purge_user(user)
    link_to_action(:remove, purge_admin_user_url(@user),
      :confirm => "Are you sure you want to remove this account, and all data associated with it from base_app?",
      :text => 'Purge',:method => :delete) if user.deleted?
  end

end

