module CacheLib
  module Basic
    class Cache
      attr_reader :limit, :ttl

      def initialize
        @limit = nil
        @ttl = nil

        @cache = Util::ExtHash.new
      end

      def initialize_copy(source)
        source_raw = source.raw

        @limit = source_raw[:limit]
        @ttl = source_raw[:ttl]

        @cache = source_raw[:cache]
      end

      def limit=(_)
        @limit = nil
      end

      def ttl=(_)
        @ttl = nil
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

      def expire
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

      def count(*pair, &block)
        @cache.count(*pair, &block)
      end

      def raw
        { limit: @limit,
          ttl: @ttl,
          cache: @cache.clone }
      end

      def inspect
        "#{self.class}, "\
        "Limit: #{@limit}, "\
        "Size: #{@cache.size}"
      end

      alias_method :[], :lookup
      alias_method :[]=, :store
      alias_method :delete, :evict
      alias_method :has_key?, :key?
      alias_method :length, :size

      protected

      def miss(key, value)
        @cache[key] = value
      end
    end
  end
end
