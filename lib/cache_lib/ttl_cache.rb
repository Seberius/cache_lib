module CacheLib
  class TtlCache
    def initialize(*args)
      limit, ttl = args

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

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
      @cache.delete(key)
      @queue.delete(key)
    end

    def inspect
      "#{self.class} with a limit of #{@limit} "\
      "currently caching #{@cache.size} items."
    end

    alias_method :[], :lookup
    alias_method :[]=, :store

    protected

    def ttl_evict
      return if @ttl.nil?

      ttl_horizon = Time.now - @ttl

      @ttl.each do |key, time|
        if time <= ttl_horizon
          @cache.delete(key)
          @queue.delete(key)
        else
          break
        end
      end
    end

    def resize
      ttl_evict

      while @cache.size > @limit
        @cache.delete(key)
        @queue.delete(key)
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

      @cache.tail if @cache.size > @limit

      value
    end
  end
end
