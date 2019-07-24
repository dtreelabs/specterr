require 'config/database_connection'

module DbInit
  include DatabaseConnection

  def intialize_db
    return unless db_config_file_exists?
    db = get_db_connection

    if db.class == PG::Connection
      result = db.exec <<-SQL
        SELECT EXISTS (SELECT 1 FROM   information_schema.tables where table_name = 'spect_analytics')
      SQL
      table_exists = result[0]['exists'] == 't'
    elsif db.class == Mysql2::Client
      result = db.query("SELECT EXISTS (SELECT 1 FROM   information_schema.tables where table_name = 'spect_analytics')")
      table_exists = result.first.values[0] == 1
    else
      table_name = db.execute <<-SQL
        SELECT name FROM sqlite_master WHERE type='table' AND name='spect_analytics';
      SQL
      table_exists = !table_name.nil?
    end


    puts "\n Conn initialized. Creating table!"

    # Create a table
    unless table_exists
      query = <<-SQL
        create table spect_analytics (
          id              SERIAL    PRIMARY KEY,
          exception       TEXT      NOT NULL,
          method          TEXT,
          path            TEXT,
          back_trace      TEXT,
          params          TEXT,
          format          TEXT,
          db_runtime      TEXT,
          view_runtime    TEXT,
          req_host        TEXT,
          agent           TEXT,
          ip_address      TEXT,
          line_no         TEXT,
          resolved        boolean,
          created_at      timestamp
        );
      SQL
      # since exec is a private method for the mysql adapter
      if db.class == PG::Connection || db.class == SQLite3::Database
        db.exec query
      elsif db.class == Mysql2::Client
        db.query query
      end
    end
  end
end
