require 'res_cache'
require 'minitest/autorun'

require_relative 'test_lru_cache'

class TestSafeLruCache < TestLruCache
  def setup
    @cache = ResCache.safe_create :lru, 5
  end
end
