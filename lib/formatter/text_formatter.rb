# try the markdown support
begin
  require 'maruku'
  ::MARKDOWN_SUPPORT = true
rescue LoadError
  ::MARKDOWN_SUPPORT = false
end

begin
  require 'redcloth'
  ::TEXTILE_SUPPORT = true
rescue LoadError
  ::TEXTILE_SUPPORT = false
end

module Formatter

  class TextFormatter

    extend ActionView::Helpers::TagHelper
    extend ActionView::Helpers::TextHelper

    def self.format(text, options={})
      options.reverse_merge!(:engine => 'textile')
      case options[:engine]
      when 'textile'
        if TEXTILE_SUPPORT
          html = textile_format(text)
        else
          html = simple_format(text)
        end
      when 'markdown'
        if MARKDOWN_SUPPORT
          html = markdown_format(text)
        else
          html = simple_format(text)
        end
      when 'simple'
        html = simple_format(text)
      end

      # Remove the formatter introduced p if exists
      if html[0..2] == "<p>" then html = html[3..-1] end
      if html[-4..-1] == "</p>" then html = html[0..-5] end

      # If html options given, then introduce a paragraph with the options
      unless options[:no_paragraph]
        start_tag = tag('p', options[:html_options], true)
        html.insert 0, start_tag
        html << "</p>"
      end
      html
    end

    def self.textile_format(text)
      redcloth = RedCloth.new(text, [:hard_breaks])
      redcloth.filter_html = false
      redcloth.no_span_caps = false
      html = redcloth.to_html(:textile)
    end

    def self.markdown_format(text)
      #html = Maruku.new(text.delete("\r").to_utf8, {:math_enabled => false}).to_html
      html = Maruku.new(text, {:math_enabled => false}).to_html
      html.gsub(/\A<div class="maruku_wrapper_div">\n?(.*?)\n?<\/div>\Z/m, '\1')
    end

  end
  
end

