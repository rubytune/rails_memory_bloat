module ReportGenerator
  class RailsProcess
    attr_accessor :requests, :pid
    @@instances = {}

    def initialize(pid)
      @pid = pid
      @requests = []
    end
    def self.find(pid)
      @@instances[pid] ||= new(pid)
    end

    def self.instances
      @@instances.values
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
end