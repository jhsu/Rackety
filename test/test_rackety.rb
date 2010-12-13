File.expand_path(File.dirname(__FILE__) + "../config.ru")
require 'test/unit'

class RacketyUnitTest < Test::Unit::TestCase
  def dummy_test
    assert Rack::Rackety != nil
  end
end
