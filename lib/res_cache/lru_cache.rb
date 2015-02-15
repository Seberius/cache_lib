module ResCache
  class LruCache < BasicCache
    def initialize(*args)
      limit, _ = args

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit
      @cache = UtilHash.new
    end

    def limit=(args)
      limit, _ = args

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      resize
    end

    def get(key)
      value = @cache.delete(key)
      if value
        @cache[key] = value
      else
        miss(key, yield)
      end
    end

    def set(key, value)
      @cache.delete(key)
      miss(key, value)
    end

    def lookup(key)
      value = @cache.delete(key)
      @cache[key] = value if value
    end

    alias_method :[], :lookup
    alias_method :[]=, :set

    protected

    def resize
      @cache.delete(@cache.tail) while @cache.size > @limit
    end

    def hit(key)
      @cache.refresh(key)
    end

    def miss(key, value)
      @cache[key] = value

      @cache.delete(@cache.tail) if @cache.size > @limit

      value
    end
  end
end
