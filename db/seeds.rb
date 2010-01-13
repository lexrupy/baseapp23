%w(admin user).each { |r| Role.create(:name => r) }
# Create admin role and user
admin_role = Role.find_by_name('admin')
user = User.create do |u|
  u.login = 'admin'
  u.password = u.password_confirmation = 'admin'
  u.email = 'nospan@example.com'
end
user.register!
user.activate!
user.roles << admin_role
user.update_attribute(:master, true)
profile = user.profile
profile.nick_name = "Administrator"
profile.save!