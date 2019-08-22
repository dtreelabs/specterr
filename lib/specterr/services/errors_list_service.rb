require_relative '../../config/database_connection'
require 'ostruct'
require 'pry'

module Specterr
  class ErrorsListService
    attr_reader :db
    include DatabaseConnection

    def initialize
      @db = get_db_connection
    end

    def call
      { errors_list: errors_list, error_graph_data: datewise_resolved_count }
    end

    def find_by_id(id)
      result = if pg_connection?
                 db.exec <<-SQL
                    SELECT * from spect_analytics
                    where id = '#{id}'
                 SQL
               else
                db.execute query
               end
      OpenStruct.new(result.map {|row| row}.first)
    end

    private

    def pg_connection?
      db.class == PG::Connection
    end

    def errors_list
      if pg_connection?
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
    end

    def datewise_resolved_count
      if pg_connection?
        result = db.exec <<-SQL
          SELECT date_trunc('day', created_at::date) AS date,
                 count(*) FILTER (WHERE NOT "resolved") AS unresolved,
                 count(*) FILTER (WHERE "resolved") AS resolved
          FROM  spect_analytics
          GROUP BY date
          ORDER BY date
        SQL
        result.map {|record| record }
      else
        # TODO: add the else part
      end
    end
  end
end
