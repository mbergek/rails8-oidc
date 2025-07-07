require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Testapp
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Change layout for edit page
    config.to_prepare do
      #Devise::RegistrationsController.layout proc{ |controller| action_name == 'edit' ? "application" : "devise" }
    end

    # Configure whether is is possible to create accounts via social platform authentication.
    # If this configuration option is false, it is only possible to log on using OAuth after
    # first having logged on using a local account and then associating that account with
    # one or more social platforms.
    #
    # Note that /users/sign_up is still accessible so it is trivial for users to create
    # their own account. Disable this route if required by the application.
    config.allow_social_account_creation = true

    # Use certificates from the google-api-client gem
    ENV['SSL_CERT_FILE'] = Gem.loaded_specs['google-api-client'].full_gem_path+'/lib/cacerts.pem'
  end
end
