#!/usr/bin/env ruby

require 'uri'
require './lib/rackety'

use Rack::Rackety

app = lambda { |env| [200, {'Content-Type' => 'text/html' }, 'Hello World!'] }
run app
