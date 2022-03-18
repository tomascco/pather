# frozen_string_literal: true

module Pather
  class RouteDrawer
    def initialize
      @routes = []
    end

    def get(path, handler: nil)
      routes << {verb: "GET", path: path, handler: handler}
    end

    def post(path)
      routes << {verb: "POST", path: path}
    end

    def to_routes
      routes
    end

    private

    attr_reader :routes
  end
end
