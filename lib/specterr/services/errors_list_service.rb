require_relative '../../config/database_connection'
require 'ostruct'

module Specterr
  class ErrorsListService
    include DatabaseConnection

    def call
      db = get_db_connection
      result = if db.class == PG::Connection
                 db.exec <<-SQL
                    SELECT * from spect_analytics
                    ORDER BY created_at DESC
                 SQL
               else
                 db.execute <<-SQL
                    SELECT * from spect_analytics
                    ORDER BY created_at DESC
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
                 db.execute <<-SQL
                    SELECT * from spect_analytics
                    where id = '#{id}'
                 SQL
               end
      OpenStruct.new(result.map {|row| row}.first)
    end
  end
end
