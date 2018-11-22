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
      puts "\n\n\n\n================================="
      puts result.values
      puts "=================================\n\n\n\n"
      result.values
    end
  end
end
