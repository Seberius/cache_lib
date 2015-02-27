module CacheLib
  module TTL
    class SafeCache < Cache
      include CacheLib::Util::SafeSync
    end
  end
end
