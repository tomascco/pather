# frozen_string_literal: true

require "test_helper"

module Pather
  class RouterTest < Minitest::Test
    def test_router
      # Arrange
      routes = {
        "GET" => [{path: "/woo/zoo", handler: proc { :get_handler }}],
        "POST" => [{path: "/foo/bar", handler: proc { :post_handler }}]
      }
      router = Router.with(routes)

      post_env = {"REQUEST_METHOD" => "POST", "REQUEST_PATH" => "/foo/bar"}
      get_env = {"REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/woo/zoo"}
      not_found_env = {"REQUEST_METHOD" => "GET", "REQUEST_PATH" => "/foo/bar"}

      # Act + Assert
      assert_equal(:post_handler, router.call(post_env))
      assert_equal(:get_handler, router.call(get_env))

      # FACT: not found routes receive a 404
      assert_equal([404, {}, ["Route not found"]], router.call(not_found_env))
    end
  end
end
