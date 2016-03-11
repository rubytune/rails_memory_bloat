require 'active_support/concern'
module RailsMemoryBloat
  module Logger
    extend ActiveSupport::Concern
    included do
      after_filter :log_memory_usage
    end

    def log_memory_usage
      rss = File.read('/proc/self/statm').split(' ')[1].to_i * 4
      records = ActiveRecordInstanceCount::HashUtils.to_sorted_array(ActiveRecord::Base.instantiated_hash)
      records.unshift(ActiveRecord::Base.total_objects_instantiated)
      project, user = @project.try(:id).inspect, @user.try(:id).inspect
      tags = ["PID: #{$$}", "Project: #{@project.try(:id).inspect}",
              "User: #{@user.try(:id).inspect}", "Mem: #{rss}",
              "Records: (#{records.join(' | ')})"]
      logger.info("[Memory Usage] #{tags.join(' ')}; #{request.fullpath}")
    end
  end
end
