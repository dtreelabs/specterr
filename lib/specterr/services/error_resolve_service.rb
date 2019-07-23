require_relative '../../config/database_connection'

module Specterr
  class ErrorResolveService
    include DatabaseConnection
    attr_reader :error_id, :db
    
    def initialize(error_id)
      @error_id = error_id
      @db = get_db_connection
    end

    def call
      result = db.exec sql_query
      OpenStruct.new(result.map {|row| row}.first)
    end

    private

    def sql_query
      if pg_connection?
        <<-SQL
          UPDATE spect_analytics 
          SET resolved = true
          WHERE id = #{error_id}
        SQL
      else
        <<-SQL
          UPDATE spect_analytics 
          SET resolved = true
          WHERE id = #{error_id}
        SQL
      end
    end

    def pg_connection?
      db.class == PG::Connection
    end
  end
end
