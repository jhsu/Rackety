#!/usr/bin/env ruby

module Rack
  class AnythingApp
    File = ::File
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Request.new(env)
      status, headers, body = @app.call(env)
      path = request.path
      body_filename = path.split('/').reverse.first
      if body_filename && !body_filename.empty? &&
         body_filename != '/' && File.exists?(body_filename)
        file = File.open("./#{body_filename}","r")
        file_body = file.read
        file.close
        [status, headers, [file_body]]
      else
        [status, headers, [body]]
      end
    end
  end
end

use Rack::AnythingApp

app = lambda { |env| [200, {'Content-Type' => 'text/html' }, 'Hello World!'] }
run app
