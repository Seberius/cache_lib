require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_ttl_cache'

class TestSafeTtlCache < TestTtlCache
  def setup
    @cache = CacheLib.safe_create :ttl, 5, 60 * 60
  end
end