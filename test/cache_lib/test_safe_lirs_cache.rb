require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_lirs_cache'

class TestSafeLirsCache < TestLirsCache
  def setup
    @cache = CacheLib.safe_create :lirs, 3, 2
  end
end
