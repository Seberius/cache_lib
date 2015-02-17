require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_lru_cache'

class TestSafeLruCache < TestLruCache
  def setup
    @cache = CacheLib.safe_create :lru, 5
  end
end
