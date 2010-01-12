#require File.dirname(__FILE__) + '/base_default_values'

class BaseScaffoldGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :force_plural => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_singular_name,
                :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    if @name == @name.pluralize && !options[:force_plural]
      logger.warning "Plural version of the model detected, using singularized version.  Override with --force-plural."
      @name = @name.singularize
    end

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)
      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('spec/controllers', controller_class_path))
      m.directory(File.join('spec/routing', controller_class_path))
      m.directory(File.join('spec/models', class_path))
      m.directory(File.join('spec/helpers', class_path))
      m.directory File.join('spec/fixtures', class_path)
      m.directory File.join('spec/views', controller_class_path, controller_file_name)
      scaffold_views.each do |action|
        m.template(
          "view_#{action}.html.erb",
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end
      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )
      m.template 'helper.rb',         File.join('app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb")
      # Specs
      m.template 'routing_spec.rb',   File.join('spec/routing', controller_class_path, "#{controller_file_name}_routing_spec.rb")
      m.template 'controller_spec.rb',File.join('spec/controllers', controller_class_path, "#{controller_file_name}_controller_spec.rb")
      m.template 'model_spec.rb',     File.join('spec/models', class_path, "#{file_name}_spec.rb")
      m.template 'helper_spec.rb',    File.join('spec/helpers', class_path, "#{controller_file_name}_helper_spec.rb")
      # View specs
      m.template "edit_erb_spec.rb",  File.join('spec/views', controller_class_path, controller_file_name, "edit.html.erb_spec.rb")
      m.template "index_erb_spec.rb", File.join('spec/views', controller_class_path, controller_file_name, "index.html.erb_spec.rb")
      m.template "new_erb_spec.rb",   File.join('spec/views', controller_class_path, controller_file_name, "new.html.erb_spec.rb")
      m.template "show_erb_spec.rb",  File.join('spec/views', controller_class_path, controller_file_name, "show.html.erb_spec.rb")
      m.route_resources controller_file_name
      m.dependency 'model', [name] + @args, :collision => :skip
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} base_scaffold ModelName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration",
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--force-plural",
             "Forces the generation of a plural ModelName") { |v| options[:force_plural] = v }
    end

    def scaffold_views
      %w[ index show new edit _form ]
    end

    def model_name
      class_name.demodulize
    end
end


module Rails
  module Generator
    class GeneratedAttribute
      def input_type
        @input_type ||= case type
          when :text                        then "textarea"
          else
            "input"
        end
      end
      def default_value
        @default_value ||= case type
          when :int, :integer               then "1"
          when :float                       then "1.5"
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string, :text               then "\"value for #{@name}\""
          when :boolean                     then "false"
          else
            ""
        end
      end
    end
  end
end

