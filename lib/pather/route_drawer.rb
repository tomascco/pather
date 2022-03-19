# frozen_string_literal: true

module Pather
  class RouteDrawer
    def initialize
      @routes = {"GET" => [], "POST" => []}.freeze
    end

    def get(path, handler:)
      routes["GET"] << {path: path, handler: handler}
    end

    def post(path, handler:)
      routes["POST"] << {path: path, handler: handler}
    end

    def to_routes
      routes.transform_values(&:freeze)
    end

    private

    attr_reader :routes
  end
end
