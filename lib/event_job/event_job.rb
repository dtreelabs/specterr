require 'config/database_connection'

module EventJob

  class EventTask
    include SuckerPunch::Job
    include DatabaseConnection

    def perform(event)
      db = get_db_connection
      if data[:exception].present?
        err_object = data[:exception_object]

        path = data[:path]
        params = data[:params]
        method = data[:method]
        format = data[:format]
        db_runtime = data[:db_runtime]
        view_runtime = data[:view_runtime]
        line_no = data[:line_no]

        header = data[:headers]
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
        VALUES (#{event.fetch(:exception,[]).join('-')}, 
                #{method},
                #{path},
                #{back_trace},
                #{params},
                #{format},
                #{db_runtime},
                #{view_runtime},
                #{req_host},
                #{agent},
                #{ip_address},
                #{line_no},
                #{Time.current})
        SQL

        db.execute(query)

      end
    end
  end
end
