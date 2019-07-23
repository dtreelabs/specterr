# frozen_string_literal: true
require 'erb'
require 'rack'
require 'rack/builder'
require 'rack/deflater'

module Specterr
  class Web
    require_relative '../specterr/services/errors_list_service'
    require_relative '../specterr/services/error_resolve_service'

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
          Rack::Response.new(content)
        when /errors\/\d+\/resolve/
          id = req.path_info.match(/\d+/)[0].to_i
          @response = Specterr::ErrorResolveService.new(id).call
          Rack::Response.new([], 301, {'location' => "/specterr/errors/#{id}"})
        when /errors\/\d+/
          id = req.path_info.match(/\d+/)[0].to_i
          @error = Specterr::ErrorsListService.new.find_by_id(id)
          template = File.read("#{VIEWS}/show.html.erb")
          content = render(template)
          Rack::Response.new(content)
        when /goodbye/
          Rack::Response.new("Goodbye Cruel World!", 500)
        else
          template = File.read("#{VIEWS}/404.html.erb")
          content = render(template)
          Rack::Response.new(content, 404)
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
