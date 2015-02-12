require 'res_cache'
require 'minitest/autorun'

require_relative 'test_lirs_cache'

class TestSafeLirsCache < TestLirsCache
  def setup
    @cache = ResCache.safe_create :lirs, 3, 2
  end
end