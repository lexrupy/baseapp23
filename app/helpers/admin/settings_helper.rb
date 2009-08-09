module Admin::SettingsHelper

  def markup_options
    [
      [t('admin.settings.index.option_markdown', :default => 'Markdown'), "markdown"],
      [t('admin.settings.index.option_textile', :default => 'Textile'), "textile"],
      [t('admin.settings.index.option_simple', :default => 'Simple'), "simple"]
    ]
  end

end

