# frozen_string_literal: true

require_relative "pather/version"
require_relative "pather/route_drawer"
require_relative "pather/router"
require "rack/handler/puma"
require "rack"

module Pather
  class Error < StandardError; end
  # Your code goes here...

  def self.draw_routes_and_start_app(with: :puma, &block)
    raise LocalJumpError if block.nil?

    drawer = RouteDrawer.new
    drawer.instance_eval(&block)

    {puma: Rack::Handler::Puma, webrick: Rack::Handler::WEBrick}
      .fetch(with)
      .run(Pather::Router.with(drawer.to_routes))
  end
end
