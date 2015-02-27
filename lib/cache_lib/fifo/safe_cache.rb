module CacheLib
  module FIFO
    class SafeCache < Cache
      include CacheLib::Util::SafeSync
    end
  end
end
