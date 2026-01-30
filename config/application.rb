require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module SimuladorBrasileiro
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Fuso horário de Brasília (UTC-3)
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local
  end
end
