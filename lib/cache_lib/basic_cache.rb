module CacheLib
  class BasicCache
    attr_reader :limit

    def initialize
      @limit = nil

      @cache = UtilHash.new
    end

    def initialize_copy(source)
      source_raw = source.raw

      @limit = source_raw[:limit]

      @cache = source_raw[:cache]
    end

    def limit=(_)
      @limit = nil
    end

    def get(key)
      has_key = true
      value = @cache.fetch(key) { has_key = false }

      if has_key
        value
      else
        miss(key, yield)
      end
    end

    def store(key, value)
      miss(key, value)
    end

    def lookup(key)
      @cache[key]
    end

    def fetch(key)
      has_key = true
      value = @cache.fetch(key) { has_key = false }

      if has_key
        value
      else
        yield if block_given?
      end
    end

    def evict(key)
      @cache.delete(key)
    end

    def clear
      @cache.clear
      nil
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

    def keys
      @cache.keys.reverse!
    end

    def values
      @cache.values.reverse!
    end

    def size
      @cache.size
    end

    def raw
      { limit: @limit,
        cache: @cache.clone }
    end

    def inspect
      "#{self.class} currently caching #{@cache.size} items."
    end

    alias_method :[], :lookup
    alias_method :[]=, :store

    protected

    def hit(key)
      @cache[key]
    end

    def miss(key, value)
      @cache[key] = value
    end
  end
end
