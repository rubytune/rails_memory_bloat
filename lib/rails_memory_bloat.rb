require "rails_memory_bloat/logger"
require "rails_memory_bloat/version"
require "active-record-instance-count"
#Rails.application.middleware.use(ActiveRecordInstanceCount::Middleware,:logger => Logger.new('/dev/null'))

module RailsMemoryBloat
  require 'rails_memory_bloat/railtie' if defined?(Rails)
end
