require 'monitor'

module CacheLib
  module Util
    module SafeSync
      include MonitorMixin

      def initialize(*args)
        super(*args)
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

      if RUBY_PLATFORM == 'java' && JRUBY_VERSION < '9.0'
        def get(key, &block)
          synchronize do
            super(key, &block)
          end
        end
      else
        def get(key)
          synchronize do
            super(key)
          end
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

      if RUBY_PLATFORM == 'java' && JRUBY_VERSION < '9.0'
        def fetch(key, &block)
          synchronize do
            super(key, &block)
          end
        end
      else
        def fetch(key)
          synchronize do
            super(key)
          end
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

      def raw
        synchronize do
          super
        end
      end

      def inspect
        synchronize do
          super
        end
      end

      alias_method :[], :lookup
      alias_method :[]=, :store
      alias_method :delete, :evict
    end
  end
end
