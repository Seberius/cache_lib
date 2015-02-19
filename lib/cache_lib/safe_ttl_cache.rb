require_relative 'safe_sync'

module CacheLib
  class SafeTtlCache < TtlCache
    include SafeSync
  end
end
