require 'rails_memory_bloat'
require "rails"

module RailsMemoryBloat
  class Railtie < Rails::Railtie
    initializer "rails_memory_bloat.after_filter" do
      Rails.application.middleware.use(ActiveRecordInstanceCount::Middleware, :logger => ::Logger.new('/dev/null'))
      
      ActiveSupport.on_load(:action_controller) do
        include RailsMemoryBloat::Logger
      end
    end
  end
end
