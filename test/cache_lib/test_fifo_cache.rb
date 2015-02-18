require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_basic_cache'

class TestFifoCache < TestBasicCache
  def setup
    @cache = CacheLib.create :fifo, 5
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

    assert_equal "#{@cache.class} with a limit of 5 "\
                 "currently caching 2 items.",
                 @cache.inspect
  end

  def test_fifo_eviction
    (1..6).each { |i| @cache.store(i, i) }

    assert_equal 5, @cache.size
    assert_equal({ 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6 },
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
end
