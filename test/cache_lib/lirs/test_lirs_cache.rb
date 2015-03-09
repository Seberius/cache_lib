require_relative '../basic/test_basic_cache'

class TestLirsCache < TestBasicCache
  def setup
    @cache = CacheLib.create :lirs, 3, 2
  end

  def test_limit
    assert_equal 5, @cache.limit
  end

  def test_set_limit
    @cache.limit = 95, 5

    assert_equal 100, @cache.limit
  end

  def test_store_ext
    @cache.store(:a, 1)
    @cache.store(:b, 2)
    @cache.store(:c, 3)
    @cache.store(:d, 4)
    @cache.store(:e, 5)
    @cache.store(:f, 6)

    raw_cache = @cache.raw

    assert_equal({a: 1, b: 2, c: 3, e: 5, f: 6},
                 raw_cache[:cache])
    assert_equal({a: nil, b: nil, c: nil, d: nil, e: nil, f: nil},
                 raw_cache[:stack])
    assert_equal({e: nil, f: nil}, raw_cache[:queue])

    @cache.store(:d, 4)

    raw_cache = @cache.raw

    assert_equal({a: 1, b: 2, c: 3, f: 6, d: 4},
                 raw_cache[:cache])
    assert_equal({b: nil, c: nil, e: nil, f: nil, d: nil},
                 raw_cache[:stack])
    assert_equal({f: nil, a: nil}, raw_cache[:queue])
  end

  def test_evict_ext
    @cache.store(:a, 1)
    @cache.store(:b, 2)
    @cache.store(:c, 3)
    @cache.store(:d, 4)
    @cache.store(:e, 5)
    @cache.lookup(:a)
    @cache.store(:f, 6)
    @cache.lookup(:e)
    @cache.store(:g, 7)

    raw_cache = @cache.raw

    assert_equal({a: 1, b: 2, c: 3, e: 5, g: 7},
                 raw_cache[:cache])
    assert_equal({c: nil, d: nil, a: nil, f: nil, e: nil, g: nil},
                 raw_cache[:stack])
    assert_equal({b: nil, g: nil}, raw_cache[:queue])

    @cache.evict(:e)

    raw_cache = @cache.raw

    assert_equal({a: 1, b: 2, c: 3, g: 7},
                 raw_cache[:cache])
    assert_equal({c: nil, d: nil, a: nil, f: nil, e: nil, g: nil},
                 raw_cache[:stack])
    assert_equal({b: nil}, raw_cache[:queue])

    @cache.evict(:c)

    raw_cache = @cache.raw

    assert_equal({a: 1, b: 2, g: 7},
                 raw_cache[:cache])
    assert_equal({b: nil, c: nil, d: nil, a: nil, f: nil, e: nil, g: nil},
                 raw_cache[:stack])
    assert_equal({}, raw_cache[:queue])

    @cache.evict(:b)

    raw_cache = @cache.raw

    assert_equal({a: 1, g: 7},
                 raw_cache[:cache])
    assert_equal({a: nil, f: nil, e: nil, g: nil},
                 raw_cache[:stack])
    assert_equal({}, raw_cache[:queue])

    @cache.store(:h, 8)
    @cache.store(:i, 9)
    @cache.evict(:i)

    raw_cache = @cache.raw

    assert_equal({a: 1, g: 7, h: 8},
                 raw_cache[:cache])
    assert_equal({a: nil, f: nil, e: nil, g: nil, h: nil, i: nil},
                 raw_cache[:stack])
    assert_equal({}, raw_cache[:queue])
  end

  def test_to_s
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal "#{@cache.class}, Limit: 5, Stack Limit: 3, "\
                 'Queue Limit: 2, Size: 2',
                 @cache.to_s
  end

  def test_raw
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    raw_cache = @cache.raw

    assert_equal({ a: 1, b: 2 }, raw_cache[:cache])
    assert_equal({ a: nil, b: nil }, raw_cache[:stack])
    assert_equal({}, raw_cache[:queue])

    assert_equal CacheLib::Util::ExtHash, raw_cache[:cache].class
    assert_equal CacheLib::Util::ExtHash, raw_cache[:stack].class
    assert_equal CacheLib::Util::ExtHash, raw_cache[:queue].class
  end

  def test_lirs_promotion
    (1..5).each { |i| @cache.store(i, i) }
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
    (1..5).each { |i| @cache.store(i, i) }
    @cache.lookup(4)
    @cache.lookup(1)
    @cache.store(6, 6)

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
    (1..5).each { |i| @cache.store(i, i) }
    @cache.limit = 5, 2
    (6..8).each { |i| @cache.store(i, i) }

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
    (1..5).each { |i| @cache.store(i, i) }
    @cache.limit = 1, 1

    raw_cache = @cache.raw

    assert_equal 2, @cache.size
    assert_equal({ 2 => 2, 3 => 3 }, raw_cache[:cache])
    assert_equal({ 3 => nil, 4 => nil, 5 => nil },
                 raw_cache[:stack])
    assert_equal({ 2 => nil }, raw_cache[:queue])
  end
end
