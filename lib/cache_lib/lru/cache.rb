module CacheLib
  module LRU
    class Cache < FIFO::Cache
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
end
