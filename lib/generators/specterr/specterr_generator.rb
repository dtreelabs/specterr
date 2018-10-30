require 'rails/generators/base'

class SpecterrGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_specterr_file
    create_file "config/specterr.yml", "adapter: sqlite3,\npool:  5,\ntimeout: 5000,\ndatabase: db/specterr.db"
  end
end
