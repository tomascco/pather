# frozen_string_literal: true

SAMPLE_APP = proc do
  handler = lambda do |env|
    method, request = env.values_at("REQUEST_METHOD", "REQUEST_PATH")

    [200, {}, ["olá #{method} esse é o caminho #{request}"]]
  end

  get("/foo/bar", handler: handler)
  post("/woo/zoo", handler: handler)
end.freeze
