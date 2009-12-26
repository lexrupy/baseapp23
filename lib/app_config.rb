class AppConfig
  def initialize
    @config_file = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[Rails.env]
  end
  
  def method_missing(sym)
    if @config_file.has_key? key = sym.to_s
      return @config_file[key]
    end
    super
  end
  
end