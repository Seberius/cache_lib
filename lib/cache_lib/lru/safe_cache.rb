module CacheLib
  module LRU
    class SafeCache < Cache
      include CacheLib::Util::SafeSync
    end
  end
end
