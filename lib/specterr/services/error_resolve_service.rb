require_relative '../../config/database_connection'
require 'pry'

module Specterr
  class ErrorResolveService
    include DatabaseConnection
    attr_reader :error_id, :db
    
    def initialize(error_id)
      @error_id = error_id
      @db = get_db_connection
    end

    def call
      result = []
      if mysql_connection?
        result = db.query(sql_query)
      else
        result = db.exec sql_query
        OpenStruct.new(result.map {|row| row}.first)
      end
    end

    private

    def sql_query
      <<-SQL
        UPDATE spect_analytics 
        SET resolved = true
        WHERE id = #{error_id}
      SQL
    end

    def pg_connection?
      db.class == PG::Connection
    end

    def mysql_connection?
      db.class == Mysql2::Client
    end
  end
end
