require "rails_memory_bloat/version"
require 'action_controller'
#Rails.application.middleware.use(ActiveRecordInstanceCount::Middleware,:logger => Logger.new('/dev/null'))
module RailsMemoryBloat
end

ActiveSupport.on_load :action_controller do
  include ActionController::RailsMemoryBloatController
end
