require "specterr/version"
require 'event_job/event_job'
require 'config/db_init'

require "sqlite3"

# {
#     controller: "PostsController",
#     action: "new",
#     params: { "action" => "new", "controller" => "posts" },
#     headers: #<ActionDispatch::Http::Headers:0x0055a67a519b88>,
#         format: :html,
#     method: "GET",
#     path: "/posts/new"
# }
# ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
#   data = args.extract_options!
#   if data[:exception].present?
#     db.execute("INSERT INTO spect_analytics (exception, method, path, line_no)
#             VALUES (?, ?, ?, ?)", [data[:exception].join('-'), data[:method], data[:path], data[:line_no]])
#   end
# end

module Specterr
  class RailsInstrumentation < ::Rails::Railtie
    extend DbInit

    intialize_db

    config.after_initialize do
      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
        EventJob::EventTask.perform_async(args.extract_options!)
      end
    end
  end
end
