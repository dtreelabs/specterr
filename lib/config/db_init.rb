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
          id          INTEGER   PRIMARY KEY   AUTOINCREMENT,
          exception   TEXT      NOT NULL,
          method      TEXT,
          path        TEXT,
          line_no     INT
        );
      SQL
    end
  end
end