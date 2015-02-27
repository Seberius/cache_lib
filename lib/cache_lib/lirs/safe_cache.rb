module CacheLib
  module LIRS
    class SafeCache < Cache
      include CacheLib::Util::SafeSync
    end
  end
end
