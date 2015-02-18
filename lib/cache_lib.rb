require_relative 'cache_lib/util_hash'
require_relative 'cache_lib/basic_cache'
require_relative 'cache_lib/fifo_cache'
require_relative 'cache_lib/lru_cache'
require_relative 'cache_lib/lirs_cache'
require_relative 'cache_lib/safe_basic_cache'
require_relative 'cache_lib/safe_fifo_cache'
require_relative 'cache_lib/safe_lru_cache'
require_relative 'cache_lib/safe_lirs_cache'
require_relative 'cache_lib/version'

module CacheLib
  def self.create(type, *args)
    case type
    when :basic then BasicCache.new(*args)
    when :fifo then FifoCache.new(*args)
    when :lru then LruCache.new(*args)
    when :lirs then LirsCache.new(*args)
    else fail ArgumentError "Cache type not recognized: #{type}"
    end
  end

  def self.safe_create(type, *args)
    case type
    when :basic then SafeBasicCache.new(*args)
    when :fifo then SafeFifoCache.new(*args)
    when :lru then SafeLruCache.new(*args)
    when :lirs then SafeLirsCache.new(*args)
    else fail ArgumentError "Cache type not recognized: #{type}"
    end
  end
end
