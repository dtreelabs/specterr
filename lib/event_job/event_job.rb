require 'config/database_connection'

module EventJob

  class EventTask
    include SuckerPunch::Job
    include DatabaseConnection

    def perform(event)

      db = get_db_connection
      db.execute("INSERT INTO spect_analytics (exception, method, path, line_no)
            VALUES (?, ?, ?, ?)", [event.fetch(:exception,[]).join('-'), event[:method], event[:path], event[:line_no]])

      puts "=" * 80
      puts event[:exception]
      puts event[:method]
      puts event[:path]
      puts event[:view_runtime]
      puts event[:db_runtime]
      puts "=" * 80
    end
  end
end
