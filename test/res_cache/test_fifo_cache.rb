require 'res_cache'
require 'minitest/autorun'

require_relative 'test_basic_cache'

class TestFifoCache < TestBasicCache
  def setup
    @cache = ResCache.create :fifo, 5
  end

  def test_limit
    assert_equal 5, @cache.limit
  end

  def test_set_limit
    @cache.limit = 90

    assert_equal 90, @cache.limit
  end

  def test_fifo_eviction
    (1..6).each { |i| @cache.set(i, i) }

    assert_equal 5, @cache.size
    assert_equal({ 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6 },
                 @cache.raw[:cache])
  end

  def test_upsize
    (1..5).each { |i| @cache.set(i, i) }
    @cache.limit = 7
    (6..8).each { |i| @cache.set(i, i) }

    assert_equal 7, @cache.size
    assert_equal({ 2 => 2, 3 => 3, 4 => 4, 5 => 5,
                   6 => 6, 7 => 7, 8 => 8 },
                 @cache.raw[:cache])
  end

  def test_downsize
    (1..5).each { |i| @cache.set(i, i) }
    @cache.limit = 3

    assert_equal 3, @cache.size
    assert_equal({ 3 => 3, 4 => 4, 5 => 5 }, @cache.raw[:cache])
  end
end
