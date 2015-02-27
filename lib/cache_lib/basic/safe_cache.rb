module CacheLib
  module Basic
    class SafeCache < Cache
      include CacheLib::Util::SafeSync
    end
  end
end
