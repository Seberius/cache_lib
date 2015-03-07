module CacheLib
  module Util
    class ExtHash < Hash
      def head_key
        keys.last
      end

      def tail
        first
      end

      def set_head(key, value)
        delete(key)
        self[key] = value
      end

      def set_tail(key, value)
        replace(Hash[key, value].merge(self))
      end

      def pop_tail
        shift
      end

      def refresh(key)
        value = delete(key)
        self[key] = value
      end
    end
  end
end
