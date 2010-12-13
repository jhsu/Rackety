require File.expand_path(File.join( File.dirname(__FILE__), "../lib/rackety/rackety.rb" ))
require 'test/unit'

class RacketyUnitTest < Test::Unit::TestCase
  def dummy_test
    assert Rack::Rackety != nil
  end
end
