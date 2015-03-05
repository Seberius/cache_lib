module CacheLib
  module Util
    module SafeSync
      def get(key, &block)
        synchronize do
          super(key, &block)
        end
      end

      def fetch(key, &block)
        synchronize do
          super(key, &block)
        end
      end

      def count(*pair, &block)
        synchronize do
          super(*pair, &block)
        end
      end
    end
  end
end
