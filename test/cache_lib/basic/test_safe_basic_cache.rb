require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_basic_cache'

class TestSafeBasicCache < TestBasicCache
  def setup
    @cache = CacheLib.safe_create :basic
  end
end
