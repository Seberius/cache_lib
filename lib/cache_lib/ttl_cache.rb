module CacheLib
  class TtlCache < BasicCache
    def initialize(*args)
      limit, ttl = args

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1
      fail ArgumentError "TTL must be :none, 0 or greater: #{limit}" unless
          limit == :none || limit >= 0

      @limit = limit
      @ttl = ttl

      @cache = UtilHash.new
      @queue = UtilHash.new
    end

    def limit=(args)
      limit, ttl = args

      limit ||= @limit
      ttl ||= @ttl

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1
      fail ArgumentError "TTL must be :none, 0 or greater: #{limit}" unless
          ttl == :none || ttl >= 0

      @limit = limit
      @ttl = ttl

      resize
    end

    def get(key)
      if hit?(key)
        hit(key)
      else
        miss(key, yield)
      end
    end

    def store(key, value)
      @cache.delete(key)
      @queue.delete(key)
      miss(key, value)
    end

    def lookup(key)
      hit(key) if hit?(key)
    end

    def fetch(key)
      if hit?(key)
        hit(key)
      else
        yield if block_given?
      end
    end

    def evict(key)
      @queue.delete(key)
      @cache.delete(key)
    end

    def expire
      ttl_evict
    end

    def inspect
      "#{self.class}, "\
      "Limit: #{@limit}, "\
      "TTL: #{@ttl}, "\
      "Size: #{@cache.size}"
    end

    alias_method :[], :lookup
    alias_method :[]=, :store

    protected

    def ttl_evict
      return if @ttl == :none

      ttl_horizon = Time.now - @ttl
      key, time = @queue.tail

      until time.nil? || time > ttl_horizon
        @queue.delete(key)
        @cache.delete(key)

        key, time = @queue.tail
      end
    end

    def resize
      ttl_evict

      while @cache.size > @limit
        key, _ = @cache.tail

        @queue.delete(key)
        @cache.delete(key)
      end
    end

    def hit?(key)
      ttl_evict

      @cache.key?(key)
    end

    def hit(key)
      @cache.refresh(key)
    end

    def miss(key, value)
      @cache[key] = value
      @queue[key] = Time.now

      while @cache.size > @limit
        key, _ = @cache.tail

        @queue.delete(key)
        @cache.delete(key)
      end

      value
    end
  end
end
