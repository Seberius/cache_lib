require 'timecop'

require_relative 'test_ttl_cache'

class TestSafeTtlCache < TestTtlCache
  def setup
    Timecop.freeze(Time.now)
    @cache = CacheLib.safe_create :ttl, 5, 5 * 60
  end

  def teardown
    Timecop.return
  end
end