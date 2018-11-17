require 'yaml'

module DatabaseConfig

  # specterr.yml - format
  # adapter: mysql2
  # database: <database_name>
  # username: <user_name>
  # password: <password>
  # host: <hostname>
  # port: <port>

  def read_database_config
    db_config_file_exists? ? db_config_from_file : default_config
  end

  def db_config_from_file
    YAML.load_file(db_config_file_path).symbolize_keys
  end

  def db_config_file_exists?
    File.exist? db_config_file_path
  end

  def db_config_file_path
    "./config/specterr.yml"
  end

  def default_config
    {
      adapter: 'sqlite3',
      pool: ENV.fetch("RAILS_MAX_THREADS") { 5 },
      timeout: 5000,
      database: "db/specterr-#{env}.db"
    }
  end

  def env
    defined?(Rails) ? Rails.env : 'development'
  end
end
