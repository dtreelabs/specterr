require 'config/database_connection'
require 'sucker_punch'

module EventJob

  class EventTask
    include SuckerPunch::Job
    include DatabaseConnection
    require_relative '../specterr/services/error_save_service.rb'
    require_relative '../specterr/services/slack_message_sender_service.rb'

    def perform(event)
      save_exception(event) 
      # make it based on config params
      send_slack_message(event)
    end

    private

    def save_exception(event)
      db = get_db_connection
      if event[:exception].present?
        exception_params = create_exception_params(event)
        Specterr::ErrorsSaveService.new.call(exception_params)
      end
    end

    def send_slack_message(event)
      exception_params = create_exception_params(event)
      puts "================ event_job 1"
      Specterr::SlackMessageSenderService.new(exception_params).call
    end

    def create_exception_params(event)
      @_exception_params ||= begin
        err_object = event[:exception_object]
        back_trace = err_object.backtrace.map do |trace|
          trace if trace.start_with? Rails.root.to_s
        end
        header = event[:headers]
        params = event[:params]

        {
          exception: event.fetch(:exception,[]).join('-'),
          path: event[:path],
          params: event[:params],
          method: event[:method],
          format: event[:format].to_s,
          db_runtime: event[:db_runtime],
          view_runtime: event[:view_runtime],
          line_no: event[:line_no],
          req_host: header.env['HTTP_HOST'],
          agent: header.env['HTTP_USER_AGENT'],
          ip_address: header.env['REMOTE_ADDR'],
          back_trace: back_trace,
          controller: params[:controller],
          action: params[:action]
        }
      end  
    end
  end
end
