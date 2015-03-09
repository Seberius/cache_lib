require 'monitor'

module CacheLib
  module Util
    module SafeSync
      def initialize(*args)
        super(*args)

        self.extend(MonitorMixin)
      end

      def initialize_copy(source)
        super(source)

        self.extend(MonitorMixin)
      end

      def limit
        synchronize do
          super
        end
      end

      def limit=(*args)
        synchronize do
          super(*args)
        end
      end

      def ttl
        synchronize do
          super
        end
      end

      def ttl=(*args)
        synchronize do
          super(*args)
        end
      end

      def get(key)
        synchronize do
          super(key)
        end
      end

      def store(key, value)
        synchronize do
          super(key, value)
        end
      end

      def lookup(key)
        synchronize do
          super(key)
        end
      end

      def fetch(key)
        synchronize do
          super(key)
        end
      end

      def peek(key)
        synchronize do
          super(key)
        end
      end

      def swap(key, value)
        synchronize do
          super(key, value)
        end
      end

      def evict(key)
        synchronize do
          super(key)
        end
      end

      def clear
        synchronize do
          super
        end
      end

      def expire
        synchronize do
          super
        end
      end

      def each
        synchronize do
          super
        end
      end

      def key?(key)
        synchronize do
          super(key)
        end
      end

      def to_a
        synchronize do
          super
        end
      end

      def size
        synchronize do
          super
        end
      end

      def count(*pair)
        synchronize do
          super(*pair)
        end
      end

      def raw
        synchronize do
          super
        end
      end

      def to_s
        synchronize do
          super
        end
      end

      alias_method :[], :lookup
      alias_method :[]=, :store
      alias_method :delete, :evict
      alias_method :has_key?, :key?
      alias_method :member?, :key?
      alias_method :length, :size
    end
  end
end
