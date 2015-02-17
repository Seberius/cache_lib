require 'cache_lib'
require 'minitest/autorun'

class TestBasicCache < MiniTest::Test
  def setup
    @cache = CacheLib.create :basic
  end

  def test_limit
    assert_equal nil, @cache.limit
  end

  def test_set_limit
    @cache.limit = 90

    assert_equal nil, @cache.limit
  end

  def test_get
    assert_equal 1, @cache.get(:a) { 1 }
    assert_equal 1, @cache.get(:a) { 2 }
    assert_equal 2, @cache.get(:b) { 2 }
  end

  def test_set
    assert_equal 1, @cache.set(:a, 1)
    assert_equal 2, @cache.set(:a, 2)
    assert_equal 2, @cache.set(:b, 2)

    assert_equal 3, @cache[:a] = 3
    assert_equal 4, @cache[:b] = 4
  end

  def test_lookup
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal 1, @cache.lookup(:a)
    assert_equal nil, @cache.lookup(:z)

    assert_equal 2, @cache[:b]
    assert_equal nil, @cache[:y]
  end

  def test_evict
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal 1, @cache.evict(:a)
    assert_equal nil, @cache.evict(:z)

    assert_equal nil, @cache.lookup(:a)
  end

  def test_clear
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal(nil, @cache.clear)

    assert_equal nil, @cache.lookup(:a)
    assert_equal nil, @cache.lookup(:b)
  end

  def test_key?
    @cache.set(:a, 1)

    assert_equal true, @cache.key?(:a)
    assert_equal false, @cache.key?(:z)
  end

  def test_to_a
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal [[:b, 2], [:a, 1]], @cache.to_a
  end

  def test_size
    @cache.set(:a, 1)

    assert_equal 1, @cache.size

    @cache.set(:b, 2)

    assert_equal 2, @cache.size
  end

  def test_raw
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal({ a: 1, b: 2 }, @cache.raw[:cache])
    assert_equal CacheLib::UtilHash, @cache.raw[:cache].class
  end

  def test_priority
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal [:b, :a], @cache.priority
  end

  def test_inspect
    @cache.set(:a, 1)
    @cache.set(:b, 2)

    assert_equal "#{@cache.class} currently caching 2 items.",
                 @cache.inspect
  end
end
