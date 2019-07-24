# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'

module Specterr
  class SlackMessageSenderService
    def call(msg)
    uri = URI.parse('https://hooks.slack.com/services/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')
    
    header = {'Content-Type': 'text/json'}
    message = {text: msg} 
    
    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = message.to_json
    
    # Send the request
    response = http.request(request)
    end
  end
end
