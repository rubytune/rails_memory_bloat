require "rails_memory_bloat/version"
require "action_controller"
require "active-record-instance-count"
#Rails.application.middleware.use(ActiveRecordInstanceCount::Middleware,:logger => Logger.new('/dev/null'))

module ActionController
  autoload :RailsMemoryBloatController, 'action_controller/rails_memory_bloat_controller'
end

module RailsMemoryBloat
end

ActiveSupport.on_load :action_controller do
  include ActionController::RailsMemoryBloatController
end
