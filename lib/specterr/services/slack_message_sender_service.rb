# frozen_string_literal: true
  require 'net/http'
  require 'uri'
  require 'json'

module Specterr
  class SlackMessageSenderService
    attr_reader :msg_params

    def initialize(msg_params)
      @msg_params = msg_params
    end

    def call
      uri = URI.parse(webhook_url)
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request.body = JSON.dump({
        "text" => create_message
      })

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    end

    private 

    def webhook_url
      ""
    end

    def create_message
      "Following execption occured :
      ```
       #{msg_params[:exception]} \n
       #{msg_params[:path]} : #{msg_params[:line_no]} \n
       #{msg_params[:controller]} - #{msg_params[:action]} 
      ```
      "
    end
  end
end
