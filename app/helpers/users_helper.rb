module UsersHelper

  def link_to_register_account
    link_to(t('.register_account_link', :default => "registering a new account"), signup_url)
  end
end

