require "rails_memory_bloat/version"
#Rails.application.middleware.use(ActiveRecordInstanceCount::Middleware,:logger => Logger.new('/dev/null'))
module RailsMemoryBloat
  # after_filter :log_memory_usage
  def self.log_memory_usage
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
