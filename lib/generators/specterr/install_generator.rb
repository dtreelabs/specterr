require 'rails/generators/base'

module Specterr
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_specterr_file
      create_file "config/specterr.yml", default_postgresql_config
    end

    def default_postgresql_config
      "adapter: postgresql\ndatabase: <database_name>\nusername: <user_name>\npassword: <password>\nhost: <hostname>\nport: <port>"
    end

    def default_sqlite_config
      "adapter: sqlite3,\npool:  5,\ntimeout: 5000,\ndatabase: db/specterr.db"
    end
  end
end
