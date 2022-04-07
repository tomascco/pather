# frozen_string_literal: true

require "test_helper"

module Pather
  class RouteDrawerTest < Minitest::Test
    def test_get_route
      # Arrange
      route_drawer = RouteDrawer.new
      handler = proc {}

      # Act
      route_drawer.get("/foo/bar", handler: handler)

      # Assert
      routes = route_drawer.to_routes
      assert_equal(1, routes["GET"].size)

      assert_equal({path: "/foo/bar", handler: handler}, routes["GET"].first)
    end

    def test_post_route
      # Arrange
      route_drawer = RouteDrawer.new
      handler = proc {}

      # Act
      route_drawer.post("/foo/bar", handler: handler)

      # Assert
      routes = route_drawer.to_routes
      assert_equal(1, routes["POST"].size)

      assert_equal({path: "/foo/bar", handler: handler}, routes["POST"].first)
    end

    def test_to_routes
      # Arrange
      route_drawer = RouteDrawer.new
      handler = proc {}

      route_drawer.get("/foo/bar", handler: handler)
      route_drawer.post("/foo/bar", handler: handler)

      # Act
      routes = route_drawer.to_routes

      # Assert
      routes.each_value do |verb_routes|
        assert_predicate(verb_routes, :frozen?)

        verb_routes.each { |route| assert_predicate(route, :frozen?) }
      end
    end
  end
end
