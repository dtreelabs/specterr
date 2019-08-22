require_relative '../../config/database_connection'
require 'ostruct'

module Specterr
  class ErrorsSaveService
    include DatabaseConnection

    def call(exception_params)
      db = get_db_connection
      query = <<-SQL
        INSERT INTO spect_analytics(
          exception, method, path, back_trace, params,
          format, db_runtime, view_runtime, req_host, agent,
          ip_address, line_no, created_at)
        VALUES ('#{PG::Connection.escape_string exception_params[:exception]}',
                '#{PG::Connection.escape_string exception_params[:method]}',
                '#{PG::Connection.escape_string exception_params[:path]}',
                '#{PG::Connection.escape_string exception_params[:back_trace].compact.join(" | ")}',
                '#{exception_params[:controller]} - #{exception_params[:action]}',
                '#{PG::Connection.escape_string exception_params[:format]}',
                '#{PG::Connection.escape_string exception_params[:db_runtime].to_s}',
                '#{PG::Connection.escape_string exception_params[:view_runtime].to_s}',
                '#{PG::Connection.escape_string exception_params[:req_host].to_s}',
                '#{PG::Connection.escape_string exception_params[:agent].to_s}',
                '#{PG::Connection.escape_string exception_params[:ip_address].to_s}',
                '#{PG::Connection.escape_string exception_params[:line_no].to_s}',
                '#{Time.current}')
      SQL
      # puts "Query: #{query}"
      db.exec(query)
    end
  end
end
