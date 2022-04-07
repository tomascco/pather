# frozen_string_literal: true

require "test_helper"

class PatherTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pather::VERSION
  end

  class FakeDrawer
    attr_reader :instance_eval_block

    def instance_eval(&block)
      @instance_eval_called = true
      @instance_eval_block = block
    end

    def to_routes
      @to_routes_called = true
    end

    def instance_eval_called?
      @instance_eval_called
    end

    def to_routes_called?
      @to_routes_called
    end
  end

  def test_draw_routes_and_build_app_exception_drawer_handling
    # Arrange
    fake_drawer = FakeDrawer.new
    block = proc {}

    # Act
    Pather.draw_routes_and_build_app(drawer: fake_drawer, autoexec: false, &block)

    # Assert
    assert_predicate(fake_drawer, :instance_eval_called?)
    assert_equal(block, fake_drawer.instance_eval_block)

    assert_predicate(fake_drawer, :to_routes_called?)
  end

  def test_draw_routes_and_build_app_exception
    # Act + Assert
    assert_raises(LocalJumpError) { Pather.draw_routes_and_build_app }
  end

  def test_draw_routes_and_build_app_autoexec
    # Act
    result = nil
    Rack::Handler::WEBrick.stub(:run, :app_runned) do
      result = Pather.draw_routes_and_build_app(with: :webrick) { get("foo/bar", handler: proc {}) }
    end

    # Assert
    assert_equal(:app_runned, result)
  end

  class Pather::Router
    attr_reader :routes
  end

  # kind of a integration test
  def test_draw_routes_and_build_app_generation
    # Arrange
    require_relative "sample_app"

    # Act
    app = Pather.draw_routes_and_build_app(autoexec: false, &SAMPLE_APP)

    # Assert
    assert_kind_of(Pather::Router, app)

    get_path, get_handler = app.routes["GET"].first.values_at(:path, :handler)
    assert_equal("/foo/bar", get_path)
    assert_kind_of(Proc, get_handler)

    post_path, post_handler = app.routes["POST"].first.values_at(:path, :handler)
    assert_equal("/woo/zoo", post_path)
    assert_kind_of(Proc, post_handler)
  end
end
