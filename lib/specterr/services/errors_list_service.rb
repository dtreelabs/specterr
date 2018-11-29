require_relative '../../config/database_connection'

module Specterr
  class ErrorsListService
    include DatabaseConnection

    def call
      db = get_db_connection
      result = if db.class == PG::Connection
                 db.exec <<-SQL
                    SELECT * from spect_analytics
                 SQL
               else
                 db.exec <<-SQL
                    SELECT * from spect_analytics
                 SQL
               end
      result.map {|row| row }
    end

    def find_by_id(id)
      db = get_db_connection
      result = if db.class == PG::Connection
                 db.exec <<-SQL
                    SELECT * from spect_analytics
                    where id = '#{id}'
                 SQL
               else
                 db.exec <<-SQL
                    SELECT * from spect_analytics
                    where id = '#{id}'
                 SQL
               end
      result.map {|row| row}.first
    end
  end
end
