require 'yaml'
require 'ya2yaml'

config_file = "#{RAILS_ROOT}/config/app_config.yml"

APP_YAML = YAML.load_file(config_file)
APP_CONFIG = APP_YAML[RAILS_ENV].symbolize_keys

sec_config_file = "#{RAILS_ROOT}/config/secret_config.yml"

if RAILS_ENV == 'production'
  SECRET_CONFIG = ENV
else
  SECRET_YAML = YAML.load_file(sec_config_file)
  SECRET_CONFIG = SECRET_YAML[RAILS_ENV]
end

$omni_auth_providers = APP_CONFIG[:omni_auth_providers] || {}

#raise SECRET_CONFIG.inspect

Rails.application.config.middleware.use OmniAuth::Builder do
  unless $omni_auth_providers.nil?
    $omni_auth_providers.each do |prov_sym|
      if SECRET_CONFIG.has_key?("#{prov_sym}_KEY") && SECRET_CONFIG.has_key?("#{prov_sym}_SECRET")
        provider prov_sym, SECRET_CONFIG["#{prov_sym}_KEY"], SECRET_CONFIG["#{prov_sym}_SECRET"]
      else
        raise "omni_auth config error for provider :#{prov_sym}"
      end
    end
  end
  
  # provider :open_id, OpenID::Store::Memory.new
#   
  # $omni_auth_providers[:open_id] = ['OpenID', 'no-needed', 'no-needed']
end
