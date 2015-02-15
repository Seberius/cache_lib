module ResCache
  class BasicCache
    attr_reader :limit

    def initialize
      @cache = UtilHash.new
      @limit = nil
    end

    def limit=(_)
      @limit = nil
    end

    def get(key)
      value = hit(key)
      if value
        value
      else
        miss(key, yield)
      end
    end

    def set(key, value)
      miss(key, value)
    end

    def evict(key)
      @cache.delete(key)
    end

    def lookup(key)
      @cache[key]
    end

    def clear
      @cache.clear
    end

    def each
      @cache.each do |pair|
        yield pair
      end
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
      { cache: @cache.clone }
    end

    def priority
      @cache.keys.reverse!
    end

    alias_method :[], :lookup
    alias_method :[]=, :set

    protected

    def hit(key)
      @cache[key]
    end

    def miss(key, value)
      @cache[key] = value
    end
  end
end
