require 'rails/generators/base'

module Specterr
  class MountGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def append_to_routes
      route "require 'specterr/web'\nmount Specterr::Web => '/specterr'\n"
    end
  end
end
