#!/usr/bin/ruby

require 'erb'
require 'optparse'

class Resource
  attr_accessor :path
  def self.find(path)
    @@instances ||= {}
    @@instances[path] || new.tap{ |x| x.path = path; @@instances[path] = x }
  end
  def route
    route = "#{path}"
    route.sub!(/^\/\d+\/(\w+)/, '/:\1_id/\1')
    route.sub!(/\?.*/, '')
    route.sub!(/\/\d+(\.\w+)?$/, '/:id')
    route.sub(/\/[0-9A-Fa-f]{64}$/, '/:token')
  end
end
class Request
  attr_accessor :previous, :process, :rss, :resource, :records, :record_count
  @@instances ||= []
  def self.new(*args)
    o = super(*args)
    (@@instances << o) && o
  end
  def self.sort(*args, &block)
    @@instances.sort(*args, &block)
  end
  def initialize(log_string)
    unless log_string =~ /PID: (\d+) Project: (\w+) User: (\w+) Mem: (\d+)/
      abort("invalid line: #{log_string.strip}")  
    end
    pid, @project, @user, @rss = [$1, $2, $3, $4].map(&:to_i)
    @process = RailsProcess.find(pid)

    unless log_string =~ /Records: \(((\d+)( \| \w+: \d+)*)\); (.+)/
      abort("invalid line: #{log_string.strip}")  
    end
    @records, @record_count, @resource = $1, $2.to_i, Resource.find($4)
    @records = @records.split(' | ')[1..-1]

    process.add_request(self)
  end
  def bloat
    rss - (previous ? previous.rss : rss)
  end
  def memory_used
    [rss - process.baseline_rss, 0].max
  end
end
class RailsProcess
  attr_accessor :requests, :pid
  @@instances = {}
  def self.find(pid)
    @@instances[pid] ||= new(pid)
  end
  def self.instances; @@instances.values; end
  def initialize(pid)
    @pid = pid
    @requests = []
  end
  def add_request(r)
    requests << r
    requests[-1].previous = requests[-2]
  end

  def csv_path
    "data/#{pid}.csv"
  end
  def png_path
    "data/#{pid}.png"
  end
  def baseline_rss
    requests[0] && requests[0].rss
  end
  def rss
    max = requests.max{ |x| x.rss }
    max && max.rss
  end
end

class ProcessView
  def initialize(processes)
    @processes = processes.sort{ |x,y| y.rss <=> x.rss }
  end
  def to_html
    ERB.new(File.read('templates/index.html.erb')).result(binding)
  end
  def render(template)
    ERB.new(File.read("templates/#{template}"),
            nil, nil, "_sub#{rand(1000000000)}").result(binding)
  end
end

log = nil
output = './output'
options = OptionParser.new do |opts|
  opts.on('-o DIR', 'Output files to DIR') do |dir|
    output = dir
  end
end.tap(&:parse!)
log = ARGV.shift or (warn(options.help) || exit(1))

system('mkdir', '-p', "#{output}/data")
system('cp', '-r', 'assets', "#{output}/assets")

File.open(log, 'r').each_line do |line|
  next unless line[0, 14] == '[Memory Usage]'
  request = Request.new(line)
end

RailsProcess.instances.each do |process|
  File.open("#{output}/#{process.csv_path}", 'w') do |csv|
    process.requests.each_with_index do |r|
      csv.puts("#{r.rss}")
    end
  end
end
IO.popen('gnuplot', 'w') do |gp|
  gp.puts('set term pngcairo size 640,480')
  gp.puts('set grid')
  gp.puts('set datafile separator ","')
  RailsProcess.instances.each do |process|
    gp.puts(%(set output "#{output}/#{process.png_path}"))
    gp.puts("set title 'PID #{process.pid}'")
    gp.puts('set xlabel "Request #"')
    gp.puts('set ylabel "Memory (MB)"')
    gp.puts('set yrange [0:800]')
    gp.puts(%(plot "#{output}/#{process.csv_path}" using 0:($1/1024) with lines notitle))
  end
  gp.puts('quit')
  gp.close
end

File.open("#{output}/index.html", 'w') do |f|
  f.write(ProcessView.new(RailsProcess.instances).to_html)
end
