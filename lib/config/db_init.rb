require 'config/database_connection'

module DbInit
  include DatabaseConnection

  def intialize_db
    db = get_db_connection

    table_name = db.execute <<-SQL
      SELECT name FROM sqlite_master WHERE type='table' AND name='spect_analytics';
    SQL

    # Create a table
    if table_name.blank?
      db.execute <<-SQL
    create table spect_analytics (
      id              INTEGER   PRIMARY KEY   AUTOINCREMENT,
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
      line_no         INT,
      created_at      DATETIME
    );
      SQL
    end
  end
end