require 'rails_memory_bloat'
require "rails"

module RailsMemoryBloat
  class Railtie < Rails::Railtie
    initializer "rails_memory_bloat.after_filter" do
      ActiveSupport.on_load(:action_controller) do
        include RailsMemoryBloat::Logger
      end
    end
  end
end
