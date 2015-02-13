require 'res_cache'
require 'minitest/autorun'

class TestResCache < MiniTest::Test
  def test_create
    basic = ResCache.create :basic
    fifo = ResCache.create :fifo, 1_000
    lru = ResCache.create :lru, 1_000
    lirs = ResCache.create :lirs, 950, 50

    assert_equal basic.class, ResCache::BasicCache
    assert_equal fifo.class, ResCache::FifoCache
    assert_equal lru.class, ResCache::LruCache
    assert_equal lirs.class, ResCache::LirsCache

    assert_equal basic.limit, nil
    assert_equal fifo.limit, 1_000
    assert_equal lru.limit, 1_000
    assert_equal lirs.limit, 1_000
  end

  def test_safe_create
    basic = ResCache.safe_create :basic
    fifo = ResCache.safe_create :fifo, 1_000
    lru = ResCache.safe_create :lru, 1_000
    lirs = ResCache.safe_create :lirs, 950, 50

    assert_equal basic.class, ResCache::SafeBasicCache
    assert_equal fifo.class, ResCache::SafeFifoCache
    assert_equal lru.class, ResCache::SafeLruCache
    assert_equal lirs.class, ResCache::SafeLirsCache

    assert_equal basic.limit, nil
    assert_equal fifo.limit, 1_000
    assert_equal lru.limit, 1_000
    assert_equal lirs.limit, 1_000
  end
end
