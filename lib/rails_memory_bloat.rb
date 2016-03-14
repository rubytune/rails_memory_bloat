require "rails_memory_bloat/logger"
require "rails_memory_bloat/version"
require "active-record-instance-count"

module RailsMemoryBloat
  require 'rails_memory_bloat/railtie' if defined?(Rails)
end
