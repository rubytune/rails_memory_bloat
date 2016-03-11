require 'rails_memory_bloat/resource'
require 'rails_memory_bloat/rails_process'
class RailsMemoryBloat::Request
  attr_accessor :previous, :process, :rss, :resource, :records, :record_count, :user_id
  @@instances ||= []

  def self.new(*args)
    o = super(*args)
    (@@instances << o) && o
  end

  def initialize(log_string)
    unless log_string =~ /PID: (\d+) Project: (\w+) User: (\w+) Mem: (\d+)/
      abort("invalid line: #{log_string.strip}")  
    end

    pid, @project, @user_id, @rss = [$1, $2, $3, $4].map(&:to_i)
    @process = RailsMemoryBloat::RailsProcess.find(pid)

    unless log_string =~ /Records: \(((\d+)( \| \w+: \d+)*)\); (.+)/
      abort("invalid line: #{log_string.strip}")  
    end

    @records, @record_count, @resource = $1, $2.to_i, RailsMemoryBloat::Resource.find($4)
    @records = @records.split(' | ')[1..-1]

    process.add_request(self)
  end

  def self.sort(*args, &block)
    @@instances.sort(*args, &block)
  end

  def bloat
    rss - (previous ? previous.rss : rss)
  end

  def memory_used
    [rss - process.baseline_rss, 0].max
  end
end
