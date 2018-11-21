require 'config/database_connection'
require 'sucker_punch'

module EventJob

  class EventTask
    include SuckerPunch::Job
    include DatabaseConnection

    def perform(event)
      db = get_db_connection
      if event[:exception].present?
        err_object = event[:exception_object]

        path = event[:path]
        params = event[:params]
        method = event[:method]
        format = event[:format]
        db_runtime = event[:db_runtime]
        view_runtime = event[:view_runtime]
        line_no = event[:line_no]

        header = event[:headers]
        req_host = header.env['HTTP_HOST']
        agent = header.env['HTTP_USER_AGENT']
        ip_address = header.env['REMOTE_ADDR']

        back_trace = err_object.backtrace.map do |trace|
          trace if trace.start_with? Rails.root.to_s
        end

        query = <<-SQL
        INSERT INTO spect_analytics(
          exception, method, path, back_trace, params,
          format, db_runtime, view_runtime, req_host, agent,
          ip_address, line_no, created_at)
        VALUES ('#{PG::Connection.escape_string event.fetch(:exception,[]).join('-')}',
                '#{PG::Connection.escape_string method}',
                '#{PG::Connection.escape_string path}',
                '#{PG::Connection.escape_string back_trace.compact.join(", ")}',
                '#{params[:controller]} - #{params[:action]}',
                '#{PG::Connection.escape_string format.to_s}',
                '#{PG::Connection.escape_string db_runtime.to_s}',
                '#{PG::Connection.escape_string view_runtime.to_s}',
                '#{PG::Connection.escape_string req_host.to_s}',
                '#{PG::Connection.escape_string agent.to_s}',
                '#{PG::Connection.escape_string ip_address.to_s}',
                '#{PG::Connection.escape_string line_no.to_s}',
                '#{Time.current}')
        SQL
        puts "Query: #{query}"
        db.exec(query)

      end
    end
  end
end
