module ProfilesHelper

  def link_to_gravatar
    link_to_ext t('.gravatar.link_name', :default => 'Gravatar'), "http://gravatar.com"
  end

  def link_to_gravatar_sign_up
    link_to_ext t('.gravatar.link_sign_up', :defaut => "Sign up now"), "http://gravatar.com/signup"
  end
end

