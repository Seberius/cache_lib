require 'res_cache'
require 'minitest/autorun'

require_relative 'test_basic_cache'

class TestLirsCache < TestBasicCache
  def setup
    @cache = ResCache.create :lirs, 3, 2
  end

  def test_limit
    assert_equal 5, @cache.limit
  end

  def test_set_limit
    @cache.limit = 95, 5

    assert_equal 100, @cache.limit
  end

  def test_raw
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    raw_cache = @cache.raw

    assert_equal({ a: 1, b: 2 }, raw_cache[:cache])
    assert_equal({ a: nil, b: nil }, raw_cache[:stack])
    assert_equal({}, raw_cache[:queue])

    assert_equal ResCache::UtilHash, raw_cache[:cache].class
    assert_equal ResCache::UtilHash, raw_cache[:stack].class
    assert_equal ResCache::UtilHash, raw_cache[:queue].class
  end

  def test_lirs_promotion
    (1..5).each { |i| @cache.set(i, i) }
    @cache.lookup(4)
    @cache.lookup(1)

    raw_cache = @cache.raw

    assert_equal({ 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5 },
                 raw_cache[:cache])
    assert_equal({ 2 => nil, 3 => nil, 5 => nil, 4 => nil, 1 => nil },
                 raw_cache[:stack])
    assert_equal({ 5 => nil, 1 => nil }, raw_cache[:queue])
  end

  def test_lirs_eviction
    (1..5).each { |i| @cache.set(i, i) }
    @cache.lookup(4)
    @cache.lookup(1)
    @cache.set(6, 6)

    raw_cache = @cache.raw

    assert_equal 5, @cache.size
    assert_equal({ 1 => 1, 2 => 2, 3 => 3, 4 => 4, 6 => 6 },
                 raw_cache[:cache])
    assert_equal({ 2 => nil, 3 => nil, 5 => nil,
                   4 => nil, 1 => nil, 6 => nil },
                 raw_cache[:stack])
    assert_equal({ 1 => nil, 6 => nil }, raw_cache[:queue])
  end

  def test_upsize
    (1..5).each { |i| @cache.set(i, i) }
    @cache.limit = 5, 2
    (6..8).each { |i| @cache.set(i, i) }

    raw_cache = @cache.raw

    assert_equal 7, @cache.size
    assert_equal({ 1 => 1, 2 => 2, 3 => 3, 4 => 4,
                   5 => 5, 7 => 7, 8 => 8 },
                 raw_cache[:cache])
    assert_equal({ 1 => nil, 2 => nil, 3 => nil, 4 => nil,
                   5 => nil, 6 => nil, 7 => nil, 8 => nil },
                 raw_cache[:stack])
    assert_equal({ 7 => nil, 8 => nil }, raw_cache[:queue])
  end

  def test_downsize
    (1..5).each { |i| @cache.set(i, i) }
    @cache.limit = 2, 1

    raw_cache = @cache.raw

    assert_equal 3, @cache.size
    assert_equal({ 1 => 1, 2 => 2, 3 => 3 }, raw_cache[:cache])
    assert_equal({ 2 => nil, 3 => nil, 4 => nil, 5 => nil },
                 raw_cache[:stack])
    assert_equal({ 1 => nil }, raw_cache[:queue])
  end
end
