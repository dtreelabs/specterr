# frozen_string_literal: true
require 'erb'
require 'rack'

module Specterr
  class Web
    def self.call(env)
      req = Rack::Request.new(env)
      case req.path_info
        when //
          [200, {"Content-Type" => "text/html"}, ["Root page"]]
        when /hello/
          [200, {"Content-Type" => "text/html"}, ["Hello World!"]]
        when /goodbye/
          [500, {"Content-Type" => "text/html"}, ["Goodbye Cruel World!"]]
        else
          [404, {"Content-Type" => "text/html"}, ["I'm Lost!"]]
      end
    end
  end
end


