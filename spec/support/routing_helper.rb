module AnagramSolver
 Engine = Class.new

  module RoutingHelper
    def mounted_at
      @mounted_at
    end

    def mount(engine_name, opts={})
      @engine_name  = engine_name
      @mounted_at   = opts[:at]
    end

    def engine_name
      @engine_name
    end

  end
end
