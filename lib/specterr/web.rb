# frozen_string_literal: true
require 'erb'
require 'rack'
require 'rack/builder'
require 'rack/deflater'

module Specterr
  class Web
    require_relative '../specterr/services/errors_list_service'

    ROOT = File.expand_path("#{File.dirname(__FILE__)}/../../web")
    VIEWS = "#{ROOT}/views"
    LAYOUT = "#{VIEWS}/layout.erb"
    ASSETS = "#{ROOT}/assets"


    def self.call(env)
      req = Rack::Request.new(env)
      case req.path_info
        when '/'
          @errors = Specterr::ErrorsListService.new.call
          template = File.read("#{VIEWS}/index.html.erb")
          content = render(template)
          ['200', {"Content-Type" => "text/html"}, [content]]
        when /errors\/\d+/
          id = req.path_info.match(/\d+/)[0].to_i
          [200, {"Content-Type" => "text/html"}, ["<html><head><title>TITLE ..</title></head><body><p>id passed is : #{id}</p></body></html>"]]
        when /goodbye/
          [500, {"Content-Type" => "text/html"}, ["Goodbye Cruel World!"]]
        else
          [404, {"Content-Type" => "text/html"}, ["I'm Lost!"]]
      end
    end

    def self.settings
      {
          root: ROOT,
          views: VIEWS
      }
    end

    private
    def self.render_(template)
      layout = File.read("#{VIEWS}/layout.html.erb")
      [template, layout].inject(nil) do | prev, temp |
        _render(temp) { prev }
      end
    end

    def self._render temp
      ERB.new(temp).result(binding)
    end

    def self.render(template)
      render_layout do
        ERB.new(template).result(binding)
      end
    end

    def self.render_layout
      layout = File.read("#{VIEWS}/layout.html.erb")
      ERB.new(layout).result(binding)
    end

  end
end


# app = Rack::Builder.new do
#   use Rack::Deflater        # GZip
#   run Specterr::Web
# end
#
# Rack::Server.start :app => app
