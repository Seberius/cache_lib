require 'cache_lib'
require 'minitest/autorun'

class TestCacheLib < MiniTest::Test
  def test_create
    basic = CacheLib.create :basic
    fifo = CacheLib.create :fifo, 1_000
    lru = CacheLib.create :lru, 1_000
    lirs = CacheLib.create :lirs, 950, 50

    assert_equal basic.class, CacheLib::BasicCache
    assert_equal fifo.class, CacheLib::FifoCache
    assert_equal lru.class, CacheLib::LruCache
    assert_equal lirs.class, CacheLib::LirsCache

    assert_equal basic.limit, nil
    assert_equal fifo.limit, 1_000
    assert_equal lru.limit, 1_000
    assert_equal lirs.limit, 1_000
  end

  def test_safe_create
    basic = CacheLib.safe_create :basic
    fifo = CacheLib.safe_create :fifo, 1_000
    lru = CacheLib.safe_create :lru, 1_000
    lirs = CacheLib.safe_create :lirs, 950, 50

    assert_equal basic.class, CacheLib::SafeBasicCache
    assert_equal fifo.class, CacheLib::SafeFifoCache
    assert_equal lru.class, CacheLib::SafeLruCache
    assert_equal lirs.class, CacheLib::SafeLirsCache

    assert_equal basic.limit, nil
    assert_equal fifo.limit, 1_000
    assert_equal lru.limit, 1_000
    assert_equal lirs.limit, 1_000
  end
end
