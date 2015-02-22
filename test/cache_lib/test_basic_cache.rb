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

  def test_store
    assert_equal 1, @cache.store(:a, 1)
    assert_equal 2, @cache.store(:a, 2)
    assert_equal 2, @cache.store(:b, 2)

    assert_equal 3, @cache[:a] = 3
    assert_equal 4, @cache[:b] = 4
  end

  def test_lookup
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal 1, @cache.lookup(:a)
    assert_equal nil, @cache.lookup(:z)

    assert_equal 2, @cache[:b]
    assert_equal nil, @cache[:z]
  end

  def test_fetch
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal 1, @cache.fetch(:a)
    assert_equal 2, @cache.fetch(:b) { 'b' }
    assert_equal nil, @cache.fetch(:y)
    assert_equal 26, @cache.fetch(:z) { 26 }

    assert_equal 2, @cache[:b]
    assert_equal nil, @cache[:z]
  end

  def test_evict
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal 1, @cache.evict(:a)
    assert_equal nil, @cache.evict(:z)

    assert_equal nil, @cache.lookup(:a)
  end

  def test_clear
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal(nil, @cache.clear)

    assert_equal nil, @cache.lookup(:a)
    assert_equal nil, @cache.lookup(:b)
  end

  def test_key?
    @cache.store(:a, 1)

    assert_equal true, @cache.key?(:a)
    assert_equal false, @cache.key?(:z)
  end

  def test_to_a
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal [[:b, 2], [:a, 1]], @cache.to_a
  end

  def test_keys
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal [:b, :a], @cache.keys
  end

  def test_values
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal [2, 1], @cache.values
  end

  def test_size
    @cache.store(:a, 1)

    assert_equal 1, @cache.size

    @cache.store(:b, 2)

    assert_equal 2, @cache.size
  end

  def test_raw
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal({ a: 1, b: 2 }, @cache.raw[:cache])
    assert_equal CacheLib::UtilHash, @cache.raw[:cache].class
  end

  def test_inspect
    @cache.store(:a, 1)
    @cache.store(:b, 2)

    assert_equal "#{@cache.class}, Limit: , Size: 2",
                 @cache.inspect
  end
end
