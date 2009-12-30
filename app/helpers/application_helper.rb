# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Yield the content for a given block. If the block yiels nothing, the optionally specified default text is shown.
  #
  #   yield_or_default(:user_status)
  #
  #   yield_or_default(:sidebar, "Sorry, no sidebar")
  #
  # +target+ specifies the object to yield.
  # +default_message+ specifies the message to show when nothing is yielded. (Default: "")
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end

  # Create tab.
  #
  # The tab will link to the first options hash in the all_options array,
  # and make it the current tab if the current url is any of the options
  # in the same array.
  #
  # +name+ specifies the name of the tab
  # +all_options+ is an array of hashes, where the first hash of the array is the tab's link and all others will make the tab show up as current.
  #
  # If now options are specified, the tab will point to '#', and will never have the 'active' state.
  def tab_to(name, all_options = nil)
    url = all_options.is_a?(Array) ? all_options[0].merge({:only_path => false}) : "#"

    current_url = url_for(:action => @current_action, :only_path => false)
    html_options = {}

    if all_options.is_a?(Array)
      all_options.each do |o|
        if url_for(o.merge({:only_path => false})) == current_url
          html_options = {:class => "current"}
          break
        end
      end
    end
    link_to(name, url, html_options)
  end

  # Admin?
  #
  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.has_role?(:admin)
  end

  # Secure mail to.
  #
  # Generate a javascript encoded mail_to link
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end

  # Link to External
  #
  # provides a link_to External resource, this is a more generic link_to with
  # adding a "external" css class to the link. all other options are the same as
  # a regular link_to
  def link_to_ext(text, path, options={})
    link_to text, path, options.reverse_merge(:class => "external")
  end


  # Link to action.
  #
  # Create a link to an specified kind of action to a resource, and observe if
  # user have access to that resource before generate the link.
  #
  # 
  # +text+ Specifies the text to be displayed on link, if <tt>nil</tt> the text will be chosen according to de <tt>action</tt>
  # +path+ is just the same path as passed to a regular link_to helper.
  # +options+ the options hash, all options for link_to helper are available
  #
  # Valid Additional Options:
  # +action+ specifies the kind of action, if fact it only affects the visual style of the link (Text and CSS)
  # +resource+ Specifies the security resource of link mannualy
  # +show_text+ If set to true, when user not authorized to access this link, a span with text link will be output instead of link
  #
  def link_to_action(text, path, options={})
    # Calculate Resource Name from path
    action = options.delete(:action)
    path = options.delete(:url) || path
    unless resource = options.delete(:resource)
      new_path = path.is_a?(String) ? path.sub(%r{^\w+://#{request.host}(?::\d+)?}, "").split("?", 2)[0] : path
      url = url_for(new_path)
      path_hash = ActionController::Routing::Routes.recognize_path(url.split('?').first, :method => options[:method] || :get)
      controller_class = "#{path_hash[:controller]}Controller".camelize.constantize
      authorize_options = {:controller => controller_class, :action => path_hash[:action]}
    else
      authorize_options = {:resource => resource}
    end
    show_text = options.delete(:show_text)
    text ||= t("app.actions.#{action}")
    if authorized?(authorize_options)
      link_to text, path, options.reverse_merge(:class => "action #{action.to_s}")
    else
      show_text ? "<span class=\"disabled_link #{action.to_s}\">#{text}</span>" : "&nbsp;"
    end
  end

  # Link to show.
  #
  # A shortcut for a link_to_action(:show, object_path, options)
  def link_to_show(text, path, options={})
    link_to_action(text, path, options.reverse_merge(:action => :show))
  end

  # Link to destroy.
  #
  # A shortcut for a link_to_action(:destroy, object_path, {:method => :delete})
  def link_to_destroy(text, path, options={})
    link_to_action(text, path,
      options.reverse_merge(:confirm => t('app.actions.destroy_confirmation', :default => 'Are you sure?'),
      :method => :delete, :action => :destroy))
  end

  # Link to new.
  #
  # A shortcut for a link_to_action(:new, objects_path, options)
  #
  # +path+ The path also accepts a Model ClassName
  # Example:
  # link_to_new(User)
  # Will Generate:
  # <a href="/users/new" class="action new">New user</a>
  def link_to_new(text, path, options={})
    if path.is_a? Class
      text ||= t("app.actions.new", :default => "New") + ' ' + path.try(:human_name).to_s.downcase
      path = options.delete(:url) || new_polymorphic_path(path) unless path.is_a? String
    end
    link_to_action(text, path, options.reverse_merge(:action => :new))
  end

  # Link to edit.
  #
  # A shortcut for a link_to_action(:edit, object_path, options)
  def link_to_edit(text, path, options={})
    unless path.is_a? String
      path = options.delete(:url) || edit_polymorphic_path(path)
    end
    link_to_action(text, path, options.reverse_merge(:action => :edit))
  end

  # Link to go.
  #
  # A shortcut for a link_to_action(:go, object_path, options)
  def link_to_go(text, path, options={})
    link_to_action(text, path, options.reverse_merge(:action => :go))
  end


  # Link to search.
  #
  # A shortcut for a link_to_action(:search, object_path, options)
  def link_to_search(text, path, options={})
    link_to_action(text, path, options.reverse_merge(:action => :search))
  end


  # Link to back.
  #
  # A shortcut for a link_to_action(:back, object_path, options)
  def link_to_back(text, path, options={})
    link_to_action(text, path, options.reverse_merge(:action => :back))
  end

  def cell(label, value)
    "<tr>
      <td class='label' nowrap='nowrap'>#{label}</td>
      <td class='value'>#{value}</td>
    </tr>"
  end

  def cell_separator
    "<tr>
      <td colspan='2' class='separator'></td>
    </tr>"
  end

  # String array for select.
  #
  # If you pass an array of strings and generate an array with the humanized form to be used in selects
  #
  # Example:
  # >> string_array_for_select(['john','alexandre','mike','stuart'])
  # => [["John", "john"], ["Alexandre", "alexandre"], ["Mike", "mike"], ["Stuart", "stuart"]]
  # If you pass a second array with the names they will be zipped into one array
  #
  # Example:
  # >> string_array_for_select(['first','second','third'],['Level One','Level Two','Level Three'])
  # => [["Level One", "first"], ["Level Two", "second"], ["Level Three", "third"]]
  def string_array_for_select(options, names=nil)
    names.nil? ? options.map { |o| [o.to_s.humanize, o.to_s] } : names.zip(options)
  end

  # Render Tabs.
  #
  # Render the set of tabs according with the current layout
  def render_tabs
    render :partial => admin_layout? ? 'admin/shared/tabs' : 'shared/tabs'
  end

  # Render Footer
  #
  # Render the default application footer partial
  def render_footer
    render :partial => 'shared/footer'
  end

  # Active Announcements
  #
  # Return the list of currently active announcements of the site
  def active_announcements
    @active_announcements ||= Admin::Announcement.current_announcements(session[:announcement_hide_time])
  end

  # Flash Message.
  #
  # A DRY flash message generator, just generate all available flash messages
  # inside styled divs and returns
  def flash_message
    messages = ""
    flash.each do |key, value|
      messages << "<div class=\"flash #{key}\">#{value}</div>"
    end
    messages
  end

  def paginate(collection, options={})
    next_label = t('plugins.will_paginate.next_label', :default => 'Next »')
    previous_label = t('plugins.will_paginate.previous_label', :default => '« Previous')
    will_paginate collection, options.reverse_merge(:prev_label => previous_label, :next_label => next_label)
  end

  def display_avatar(user, options={})
    gravatar_for user, options.reverse_merge(:alt => 'Avatar', :default => "#{configatron.site_url}/images/gravatar-80.png")
  end
  
  def activate_first_element_of(form)
    content_for :javascript do
    	javascript_tag "Form.focusFirstElement('#{form}')"
    end
  end

end

