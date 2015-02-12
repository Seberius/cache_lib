module ResCache
  class LruCache

    attr_reader :limit

    def initialize(*args)
      limit, _ = args

      raise ArgumentError.new("Cache Limit must be 1 or greater: #{limit}") if limit.nil? || limit < 1

      @limit = limit
      @cache = UtilHash.new
    end

    def limit=(args)
      limit, _ = args
      raise ArgumentError.new("Cache Limit must be 1 or greater: #{limit}") if limit.nil? || limit < 1

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
      if value
        @cache[key] = value
      else
        nil
      end
    end

    def evict(key)
      @cache.delete(key)
    end

    def clear
      @cache.clear
    end

    def key?(key)
      @cache.key?(key)
    end

    def to_a
      @cache.to_a.reverse!
    end

    def size
      @cache.size
    end

    def raw
      {cache: @cache.clone}
    end

    def priority
      @cache.keys.reverse!
    end

    alias_method :[], :lookup
    alias_method :[]=, :set

    protected

    def resize
      while @cache.size > @limit
        @cache.delete(@cache.get_tail)
      end
    end

    def hit(key)
      @cache.refresh(key)
    end

    def miss(key, value)
      @cache[key] = value

      @cache.delete(@cache.get_tail) if @cache.size > @limit

      value
    end
  end
end