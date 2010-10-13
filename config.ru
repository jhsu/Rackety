#!/usr/bin/env ruby

module Rack
  class Rackety
    File = ::File
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Request.new(env)
      status, headers, body = @app.call(env)
      path = request.path
      if request.post?
        if file = request.params['file']
          FileUtils.rm("./uploads/#{file[:filename]}") if File.exists?("./uploads/#{file[:filename]}")
          FileUtils.mv file[:tempfile].path, "./uploads/#{file[:filename]}"
          [status, headers, [request.params.to_s]]
        else
          [status, headers, [request.params.to_s]]
        end
      else
        body_filename = path.split('/').reverse.first.gsub(/\?.*/, '')
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
end

use Rack::Rackety

app = lambda { |env| [200, {'Content-Type' => 'text/html' }, 'Hello World!'] }
run app
