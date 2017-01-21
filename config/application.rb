require_relative 'boot'

require 'rails/all'
require 'dotenv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Dotenv.load
Bundler.require(*Rails.groups)

module Flashcards
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
    config.time_zone = 'Kyiv'
    config.active_record.default_timezone = :local
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    I18n.config.enforce_available_locales = false
    I18n.available_locales = %i(ru en)
    I18n.default_locale = :ru
  end
end
