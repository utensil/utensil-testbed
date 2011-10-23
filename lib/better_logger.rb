# gist: 1091611
# You must require this file in application.rb, above the Application
# definition, for this to work. For example:
#
#   # Syslog-like Rails logs
#   if Rails.env.production?
#     require File.expand_path('../../lib/better_logger', __FILE__)
#   end
#
#   module MyApp
#     class Application < Rails::Application

require 'active_support/buffered_logger'

class BetterLogger < ActiveSupport::BufferedLogger

  SEVERITIES = Severity.constants.sort_by{|c| Severity.const_get(c) }

  def add(severity, message = nil, progname = nil, &block)
    return if @level > severity
    message = (message || (block && block.call) || progname).to_s
    # Add timestamp, severity, and pid, kinda like syslog
    log = "#{Time.now.to_formatted_s(:db)} #{SEVERITIES[severity]}"
    log << " [#{$$}] #{message.gsub(/^\n+/, '')}"
    # If a newline is necessary then create a new message ending with a newline.
    log << "\n" unless log[-1] == ?\n
    buffer << log
    auto_flush
    message
  end

  class Railtie < ::Rails::Railtie
    initializer "swap in BetterLogger" do
      Rails.logger = BetterLogger.new(Rails.application.config.paths.log.first)
      ActiveSupport::Dependencies.logger = Rails.logger
      Rails.cache.logger = Rails.logger
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.logger = Rails.logger
      end
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.logger = Rails.logger
      end
      ActiveSupport.on_load(:action_mailer) do
        ActionMailer::Base.logger = Rails.logger
      end
    end
  end

end