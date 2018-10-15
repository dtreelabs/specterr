module DatabaseConfig

  # spectr.yml - format
  # adapter: mysql2
  # database: <database_name>
  # username: <user_name>
  # password: <password>
  # host: <hostname>
  # port: <port>

  def read_database_config
    require 'yaml'

    config = {}
    spectr_config_file = "#{Rails.root}/config/spectr.yml"
    if File.exists? spectr_config
      spectr_config = YAML.load_file(spectr_config_file)
      config = spectr_config.symbolize_keys
    else
      config = default_config
    end
    config
  end

# If spectr.yml is not present then use default config of sqlite to use as persistent database
  def default_config
    {
      adapter: sqlite3,
      pool: ENV.fetch("RAILS_MAX_THREADS") { 5 },
      timeout: 5000,
      database: "db/spectr-#{Rails.env}.db"
    }
  end
end