require 'config/database_connection'

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
        VALUES ('#{event.fetch(:exception,[]).join('-')}', 
                '#{method}',
                '#{path}',
                '#{PG::Connection.escape_string(back_trace.compact.join(", "))}',
                '#{params}',
                '#{format}',
                '#{db_runtime}',
                '#{view_runtime}',
                '#{req_host}',
                '#{agent}',
                '#{ip_address}',
                '#{line_no}',
                '#{Time.current}')
        SQL
        puts "Query: #{query}"
        db.exec(query)

      end
    end
  end
end
