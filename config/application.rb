require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module TacoTruck
  class Application < Rails::Application

    config.middleware.insert_before ActionDispatch::Static, Rack::Cors, :debug => true, :logger => Rails.logger do
      allow do
        origins '*'

        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :delete, :put, :options],
                 :max_age => 0
      end
    end
  end
end
