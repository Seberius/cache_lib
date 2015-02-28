require 'cache_lib'
require 'minitest'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

class TestCacheLib < MiniTest::Test
  def test_create
    basic = CacheLib.create :basic
    fifo = CacheLib.create :fifo, 1_000
    lru = CacheLib.create :lru, 1_000
    ttl = CacheLib.create :ttl, 1_000, 5 * 60
    lirs = CacheLib.create :lirs, 950, 50

    assert_equal basic.class, CacheLib::Basic::Cache
    assert_equal fifo.class, CacheLib::FIFO::Cache
    assert_equal lru.class, CacheLib::LRU::Cache
    assert_equal ttl.class, CacheLib::TTL::Cache
    assert_equal lirs.class, CacheLib::LIRS::Cache

    assert_equal basic.limit, nil
    assert_equal fifo.limit, 1_000
    assert_equal lru.limit, 1_000
    assert_equal ttl.limit, 1_000
    assert_equal lirs.limit, 1_000
  end

  def test_safe_create
    basic = CacheLib.safe_create :basic
    fifo = CacheLib.safe_create :fifo, 1_000
    lru = CacheLib.safe_create :lru, 1_000
    ttl = CacheLib.safe_create :ttl, 1_000, 5 * 60
    lirs = CacheLib.safe_create :lirs, 950, 50

    assert_equal basic.class, CacheLib::Basic::SafeCache
    assert_equal fifo.class, CacheLib::FIFO::SafeCache
    assert_equal lru.class, CacheLib::LRU::SafeCache
    assert_equal ttl.class, CacheLib::TTL::SafeCache
    assert_equal lirs.class, CacheLib::LIRS::SafeCache

    assert_equal basic.limit, nil
    assert_equal fifo.limit, 1_000
    assert_equal lru.limit, 1_000
    assert_equal ttl.limit, 1_000
    assert_equal lirs.limit, 1_000
  end
end
