class Admin::SettingsController < ApplicationController
  require_role :admin

  def index
    # Render index.html.erb
  end

  def update
    unless params[:settings].blank?
      params[:settings].each do |input|
        setting = Setting.find(input[0])

        value = case(setting.field_type)
        when 'string':        input[1].to_s
        when 'integer':       input[1].to_i
        when 'float':         input[1].to_f
        end

        setting.update_attribute(:value, value)
      end

      flash[:notice] = t('admin.settings.update.flash.notice', :default => "Settings have been saved.")
    end
    redirect_to :action => :index
  end
end

