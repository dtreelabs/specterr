require 'config/database_config'
require 'pg'

module DatabaseConnection

  include DatabaseConfig
  # TODO - get database details from yml
  # Its not a singleton yet
  # Have to create a singleton if not already
  def get_db_connection
    config = read_database_config
    if config.dig(:adapter) == 'postgresql'
      config[:user] = config.delete(:username) if config[:username]
      config[:dbname] = config.delete(:database) if config[:database]
      config.delete(:adapter)
      valid_param_keys = PG::Connection.conndefaults_hash.keys + [:requiressl]
      config.slice!(*valid_param_keys)
      @db ||= PG::Connection.new(config)
    else
      @db ||= SQLite3::Database.open("spectacles-#{Rails.env}.db")
    end
  end
end
