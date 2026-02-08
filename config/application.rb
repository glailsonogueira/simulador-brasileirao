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
    
    # Configuração de locale (Internacionalização)
    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = [:'pt-BR', :en]
    config.i18n.fallbacks = [:'pt-BR']
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end