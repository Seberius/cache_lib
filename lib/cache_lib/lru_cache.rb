module CacheLib
  class LruCache < BasicCache
    def initialize(*args)
      limit, _ = args

      fail ArgumentError, "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      @cache = UtilHash.new
    end

    def limit=(args)
      limit, _ = args

      limit ||= @limit

      fail ArgumentError, "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      resize
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

    protected

    def resize
      @cache.pop_tail while @cache.size > @limit
    end

    def hit(key)
      @cache.refresh(key)
    end

    def miss(key, value)
      @cache[key] = value

      @cache.pop_tail if @cache.size > @limit

      value
    end
  end
end
