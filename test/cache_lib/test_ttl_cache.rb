require 'timecop'

require_relative 'test_basic_cache'

class TestTtlCache < TestBasicCache
  def setup
    Timecop.freeze(Time.now)
    @cache = CacheLib.create :ttl, 5, 5 * 60
  end

  def teardown
    Timecop.return
  end

  def test_limit
    assert_equal 5, @cache.limit
  end

  def test_set_limit
    @cache.limit = 90

    assert_equal 90, @cache.limit
  end

  def test_inspect
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal "#{@cache.class}, Limit: 5, TTL: 300, Size: 2",
                 @cache.inspect
  end

  def test_lru_promotion
    (1..5).each { |i| @cache.store(i, i) }
    @cache.lookup(3)
    @cache.lookup(1)

    assert_equal({ 2 => 2, 4 => 4, 5 => 5, 3 => 3, 1 => 1 },
                 @cache.raw[:cache])
  end

  def test_lru_eviction
    (1..5).each { |i| @cache.store(i, i) }
    @cache.lookup(3)
    @cache.lookup(1)
    @cache.store(6, 6)

    assert_equal 5, @cache.size
    assert_equal({ 4 => 4, 5 => 5, 3 => 3, 1 => 1, 6 => 6 },
                 @cache.raw[:cache])
  end

  def test_upsize
    (1..5).each { |i| @cache.store(i, i) }
    @cache.limit = 7
    (6..8).each { |i| @cache.store(i, i) }

    assert_equal 7, @cache.size
    assert_equal({ 2 => 2, 3 => 3, 4 => 4, 5 => 5,
                   6 => 6, 7 => 7, 8 => 8 },
                 @cache.raw[:cache])
  end

  def test_downsize
    (1..5).each { |i| @cache.store(i, i) }
    @cache.limit = 3

    assert_equal 3, @cache.size
    assert_equal({ 3 => 3, 4 => 4, 5 => 5 }, @cache.raw[:cache])
  end

  # TTL tests using Timecop
  def test_ttl_eviction_on_access
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    Timecop.freeze(Time.now + 330)

    @cache.store(:c, 3)

    assert_equal({ :c => 3 }, @cache.raw[:cache])
  end

  def test_ttl_eviction_on_expire
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    Timecop.freeze(Time.now + 330)

    @cache.expire

    assert_equal({}, @cache.raw[:cache])
  end

  def test_ttl_eviction_on_new_limit
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    Timecop.freeze(Time.now + 330)

    @cache.limit = 10

    assert_equal({}, @cache.raw[:cache])
  end

  def test_ttl_eviction_on_new_ttl
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    Timecop.freeze(Time.now + 330)

    @cache.limit = nil, 10 * 60

    assert_equal({ :a => 1, :b => 2 }, @cache.raw[:cache])

    @cache.limit = nil, 2 * 60

    assert_equal({}, @cache.raw[:cache])
  end

  def test_ttl_precedence_over_lru
    @cache.store(:a, 1)

    Timecop.freeze(Time.now + 60)

    @cache.store(:b, 2)
    @cache.store(:c, 3)
    @cache.store(:d, 4)
    @cache.store(:e, 5)

    @cache.lookup(:a)

    assert_equal [[:a, 1], [:e, 5], [:d, 4], [:c, 3], [:b, 2]],
                 @cache.to_a

    Timecop.freeze(Time.now + 270)

    @cache.store(:f, 6)

    assert_equal [[:f, 6], [:e, 5], [:d, 4], [:c, 3], [:b, 2]],
                 @cache.to_a
  end
end
