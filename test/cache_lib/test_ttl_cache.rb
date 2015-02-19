require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_lru_cache'

class TestTtlCache < TestLruCache
  def setup
    @cache = CacheLib.create :ttl, 5, 60 * 60
  end
end
