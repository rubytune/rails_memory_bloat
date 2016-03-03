require 'erb'
class RailsMemoryBloat::ProcessView
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
