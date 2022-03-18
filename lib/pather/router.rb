# frozen_string_literal: true

module Pather
  class Router
    def self.with(...)
      new(...)
    end

    def initialize(routes)
      @routes = routes
    end

    def call(env)
      method, path = env.values_at("REQUEST_METHOD", "REQUEST_PATH")

      case routes
      in [*, {verb: ^method, path: ^path, handler: handler}, *]
        handler.call(env)
      else
        [404, {}, ["Rota não encontrada"]]
      end
    end

    private

    attr_reader :routes
  end
end
