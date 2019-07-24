require_relative '../../config/database_connection'
require 'ostruct'
require 'pry'

module Specterr
  class ErrorsListService
    include DatabaseConnection

    def call
      query = <<-SQL
        SELECT * from spect_analytics
        ORDER BY created_at DESC
      SQL
      db = get_db_connection
      result = if pg_connection?(db)
                db.exec query
               elsif mysql_connection?(db)
                 db.query query
               else
                 db.execute query
               end
      result.map {|row| row }
    end

    def find_by_id(id)
      query = <<-SQL
        SELECT * from spect_analytics
        where id = '#{id}'
      SQL
      db = get_db_connection
      result = if pg_connection?(db)
                db.exec query
               elsif mysql_connection?(db)
                db.query query  
               else
                db.execute query
               end
      OpenStruct.new(result.map {|row| row}.first)
    end

    def pg_connection?(db)
      db.class == PG::Connection
    end

    def mysql_connection?(db)
      db.class == Mysql2::Client
    end
  end
end
