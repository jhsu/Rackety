#!/usr/bin/env ruby

require 'uri'

module Rack
  class Rackety
    File = ::File
    def initialize(app)
      @app = app
    end

    def call(env)
      @request = Request.new(env)
      params = @request.params
      status, headers, @body = @app.call(env)
      if @request.post?
        if params.has_key?('file') && file = params.delete('file')
          FileUtils.mv file[:tempfile].path, "./uploads/#{file[:filename]}"
        end
      end
      if params.has_key?('redirect_to') && redirect_to = params.delete('redirect_to')
        status = 303
        url_params = {:identifier => params.delete('identifier')}.merge({:description => params["description"]})
        url_params = URI.escape(url_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
        headers = headers.merge({'Location' => redirect_to + "?#{url_params}" })
      end
      if response_body
        [status, headers, [response_body]]
      else
        [status, headers, [@body]]
      end
    end

    def response_body
      @response_body ||= begin
        if path = @request.path.split('/').reverse.first
          response_filename = path.gsub(/\?.*/, '')
        end
        if response_filename && File.exists?(response_filename)
          file = File.open("./#{response_filename}", "r")
          @body = file.read
          file.close
          @body
        else
          nil
        end
      end
    end
  end
end

use Rack::Rackety

app = lambda { |env| [200, {'Content-Type' => 'text/html' }, 'Hello World!'] }
run app
