module CacheLib
  class LruCache < FifoCache
    def initialize(*args)
      limit, _ = args

      fail ArgumentError, "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      @cache = UtilHash.new
    end

    def get(key)
      has_key = true
      value = @cache.delete(key) { has_key = false }
      if has_key
        @cache[key] = value
      else
        miss(key, yield)
      end
    end

    def store(key, value)
      @cache.delete(key)
      miss(key, value)
    end

    def lookup(key)
      has_key = true
      value = @cache.delete(key) { has_key = false }
      @cache[key] = value if has_key
    end

    def fetch(key)
      has_key = true
      value = @cache.delete(key) { has_key = false }
      if has_key
        @cache[key] = value
      else
        yield if block_given?
      end
    end

    alias_method :[], :lookup
    alias_method :[]=, :store
    alias_method :delete, :evict
  end
end
