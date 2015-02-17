require 'cache_lib'
require 'minitest/autorun'

require_relative 'test_fifo_cache'

class TestSafeFifoCache < TestFifoCache
  def setup
    @cache = CacheLib.safe_create :fifo, 5
  end
end
