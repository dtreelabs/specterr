require 'rails/generators/base'


class SpectrGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_spectr_file
    create_file "config/spectr.yml", "adapter: sqlite3,\npool:  5,\ntimeout: 5000,\ndatabase: db/spectr.db"
  end
end
