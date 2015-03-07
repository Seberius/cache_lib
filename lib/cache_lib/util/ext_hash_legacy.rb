module CacheLib
  module Util
    class ExtHash
      def pop_tail
        delete(first[0])
      end
    end
  end
end
