require_relative 'cache_lib/util_hash'
require_relative 'cache_lib/basic_cache'
require_relative 'cache_lib/fifo_cache'
require_relative 'cache_lib/lru_cache'
require_relative 'cache_lib/ttl_cache'
require_relative 'cache_lib/lirs_cache'
require_relative 'cache_lib/safe_basic_cache'
require_relative 'cache_lib/safe_fifo_cache'
require_relative 'cache_lib/safe_lru_cache'
require_relative 'cache_lib/safe_ttl_cache'
require_relative 'cache_lib/safe_lirs_cache'
require_relative 'cache_lib/version'

module CacheLib
  CACHES = { basic: BasicCache, fifo: FifoCache,
             lru: LruCache, ttl: TtlCache,
             lirs: LirsCache }

  SAFE_CACHES = { basic: SafeBasicCache, fifo: SafeFifoCache,
                  lru: SafeLruCache, ttl: SafeTtlCache,
                  lirs: SafeLirsCache }

  def self.create(type, *args)
    self.cache_new(type, CACHES, *args)
  end

  def self.safe_create(type, *args)
    self.cache_new(type, SAFE_CACHES, *args)
  end

  protected

  def self.cache_new(type, caches, *args)
    fail ArgumentError "Cache type not recognized: #{type}" unless caches.key?(type)

    caches[type].new(*args)
  end
end
