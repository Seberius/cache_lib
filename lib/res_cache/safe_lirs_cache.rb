require_relative 'safe_sync'

module ResCache
  class SafeLirsCache < LirsCache
    include SafeSync
  end
end
