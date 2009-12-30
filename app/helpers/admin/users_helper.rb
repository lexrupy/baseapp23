module Admin::UsersHelper

  def role_list(user)
    roles = user.roles.collect{ |r| r.name.humanize }
    roles.join " | "
  end

  def link_to_suspend_user(user)
    link_to_action(t('admin.users.actions.suspend', :default => 'Suspend'), suspend_admin_user_url(user),
      :method => :put, :action => :suspend) if ['pending', 'passive', 'active'].include?(user.state)
  end

  def link_to_unsuspend_user(user)
    link_to_action(t('admin.users.actions.unsuspend', :default => 'Unsuspend'), unsuspend_admin_user_url(user),
      :method => :put, :action => :yes) if user.suspended?
  end

  def link_to_activate_user(user)
    link_to_action(t('admin.users.actions.activate', :default => 'Activate'), activate_admin_user_url(user),
      :method => :put, :action => :yes) if ['pending', 'passive'].include?(user.state)
  end

  def link_to_delete_user(user)
    link_to_destroy(nil, admin_user_url(user)) unless user.deleted?
  end

  def link_to_purge_user(user)
    link_to_action(t('admin.users.actions.purge', :default => 'Purge'), purge_admin_user_url(@user),
      :confirm => t('admin.users.actions.purge_confirmation', :default => "Are you sure you want to remove this account, and all data associated with it from base_app?"),
      :method => :delete, :action => :remove) if user.deleted?
  end

end

