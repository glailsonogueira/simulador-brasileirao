require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  
  config.assets.compile = false
  
  config.active_storage.service = :local
  
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  
  config.log_tags = [ :request_id ]
  
  config.action_mailer.perform_caching = false
  
  config.i18n.fallbacks = true
  
  config.active_support.report_deprecations = false
  
  config.log_formatter = ::Logger::Formatter.new
  
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  
  config.active_record.dump_schema_after_migration = false
  
  config.hosts << "simulador-brasileirao.onrender.com"

  # Configuração de email para produção com SendGrid
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    domain: 'simulador-brasileirao.onrender.com',
    user_name: 'apikey',
    password: ENV['SENDGRID_API_KEY'],
    authentication: :plain,
    enable_starttls_auto: true
  }
  config.action_mailer.default_url_options = { 
    host: 'simulador-brasileirao.onrender.com',
    protocol: 'https'
  }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

end
