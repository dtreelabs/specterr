require "specterr/version"
require 'event_job/event_job'
require 'config/db_init'
require "sqlite3"

module Specterr
  if defined?(::Rails::Railtie)
    class RailsInstrumentation < ::Rails::Railtie
      extend DbInit
      intialize_db
      config.after_initialize do
        ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
          EventJob::EventTask.perform_async(args.extract_options!)
        end
        
        ActiveSupport::Notifications.subscribe "deprecation.rails" do |*args|
          puts "============= Deprecation ========================="
          puts "args"
          puts "==================================================="
          EventJob::EventTask.perform_async(args.extract_options!)
        end
        
      end
    end
  end
end
