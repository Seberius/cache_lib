require_relative 'safe_sync'

module CacheLib
  class SafeLirsCache < LirsCache
    include SafeSync
  end
end
