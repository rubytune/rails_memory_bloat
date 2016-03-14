module ReportGenerator
  class Resource
    attr_accessor :path
    def self.find(path)
      @@instances ||= {}
      @@instances[path] || new.tap do  |x|
        x.path = path
        @@instances[path] = x
      end
    end

    def route
      route = "#{path}"
      route.sub!(/^\/\d+\/(\w+)/, '/:\1_id/\1')
      route.sub!(/\?.*/, '')
      route.sub!(/\/\d+(\.\w+)?$/, '/:id')
      route.sub(/\/[0-9A-Fa-f]{64}$/, '/:token')
    end
  end
end
