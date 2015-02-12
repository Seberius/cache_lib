require 'res_cache'
require 'minitest/autorun'

require_relative 'test_basic_cache'

class TestSafeBasicCache < TestBasicCache
  def setup
    @cache = ResCache.safe_create :basic
  end
end