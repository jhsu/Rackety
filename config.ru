#!/usr/bin/env ruby

module Rack
  class Rackety
    File = ::File
    def initialize(app)
      @app = app
    end

    def call(env)
      @request = Request.new(env)
      status, headers, @body = @app.call(env)
      if @request.post?
        if file = @request.params['file']
          FileUtils.mv file[:tempfile].path, "./uploads/#{file[:filename]}"
        end
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
