require 'res_cache'
require 'minitest/autorun'

require_relative 'test_fifo_cache'

class TestSafeFifoCache < TestFifoCache
  def setup
    @cache = ResCache.safe_create :fifo, 5
  end
end
