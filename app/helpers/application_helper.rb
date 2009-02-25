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

  # Return true if the currently logged in user is an admin
  def admin?
    logged_in? && current_user.has_role?(:admin)
  end

  # Return true if current selected layout is the admin layout
  def admin_layout?
    @current_layout_selected == 'admin'
  end

  # Write a secure email adress
  def secure_mail_to(email)
    mail_to email, nil, :encode => 'javascript'
  end

  # Link Helpers

  def link_to_ext(text, path, options={})
    link_to text, path, options.reverse_merge(:class => "external")
  end

  def link_to_action(action, path, options={})
    text = options.delete(:text) || MAPPED_ACTION_TEXT[action.to_sym]
    link_to text, path, options.reverse_merge(:class => "action #{action.to_s}")
  end

  def link_to_show(path, options={})
    link_to_action(:show, path, options)
  end

  def link_to_destroy(path, options={})
    link_to_action(:destroy, path, options.reverse_merge(:confirm => 'Are you sure?', :method => :delete))
  end

  def link_to_new(path, options={})
    if path.is_a? Class
      options[:text] ||= "New #{path.class_name.downcase}"
      path = new_polymorphic_path(path) unless path.is_a? String
    end
    link_to_action(:new, path, options)
  end

  def link_to_edit(path, options={})
    unless path.is_a? String
      path = edit_polymorphic_path(path)
    end
    link_to_action(:edit, path, options)
  end

  def link_to_go(path, options={})
    link_to_action(:go, path, options)
  end

  def link_to_search(path, options={})
    link_to_action(:search, path, options)
  end

  def link_to_back(path, options={})
    link_to_action(:back, path, options)
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

  def string_array_for_select(options)
    options.map { |o| [o.to_s.humanize, o.to_s] }
  end

  def render_tabs
    render :partial => admin_layout? ? 'admin/shared/tabs' : 'shared/tabs'
  end

  def active_announcements
    @active_announcements ||= Admin::Announcement.current_announcements(session[:announcement_hide_time])
  end

  #DRY flash messages
  def flash_message
    messages = ""
    flash.each do |key, value|
      messages << "<div class=\"flash #{key}\">#{value}</div>"
    end
    messages
  end
end
