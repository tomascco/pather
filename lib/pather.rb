# frozen_string_literal: true

require_relative "pather/version"
require_relative "pather/route_drawer"
require_relative "pather/router"
require "rack/handler/puma"
require "rack"

module Pather
  class Error < StandardError; end

  AVAILABLE_SERVERS = {puma: Rack::Handler::Puma, webrick: Rack::Handler::WEBrick}.freeze

  def self.draw_routes_and_build_app(with: :puma, drawer: RouteDrawer.new, autoexec: true, &block)
    raise LocalJumpError, "No routes' block passed" if block.nil?

    drawer.instance_eval(&block)

    app = Pather::Router.with(drawer.to_routes)
    return app unless autoexec

    AVAILABLE_SERVERS
      .fetch(with)
      .run(app)
  end
end
