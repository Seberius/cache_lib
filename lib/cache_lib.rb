require_relative 'cache_lib/basic'
require_relative 'cache_lib/fifo'
require_relative 'cache_lib/lru'
require_relative 'cache_lib/ttl'
require_relative 'cache_lib/lirs'
require_relative 'cache_lib/version'

module CacheLib
  extend self

  CACHES = { basic: Basic::Cache,
             fifo:  FIFO::Cache,
             lru:   LRU::Cache,
             ttl:   TTL::Cache,
             lirs:  LIRS::Cache }

  SAFE_CACHES = { basic: Basic::SafeCache,
                  fifo:  FIFO::SafeCache,
                  lru:   LRU::SafeCache,
                  ttl:   TTL::SafeCache,
                  lirs:  LIRS::SafeCache }

  def create(type, *args)
    self.cache_new(type, CACHES, *args)
  end

  def safe_create(type, *args)
    self.cache_new(type, SAFE_CACHES, *args)
  end

  protected

  def cache_new(type, caches, *args)
    fail ArgumentError "Cache type not recognized: #{type}" unless
        caches.key?(type)

    caches[type].new(*args)
  end
end
