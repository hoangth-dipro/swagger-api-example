require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DemoSwaggerRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Save records by JST
    config.active_record.default_timezone = :local

    # Add the dir under the lib to autoload_paths
    config.autoload_paths += Dir[Rails.root.join('lib')]
    config.autoload_paths << Rails.root.join("app", "services")

    ### Grape::Rabl ###
    config.middleware.use(Rack::Config) do |env|
      env['api.tilt.root'] = Rails.root.join('app', 'views', 'api')
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options, :put, :delete]
      end
    end
  end
end
