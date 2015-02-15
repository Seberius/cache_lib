require_relative 'safe_sync'

module ResCache
  class SafeLruCache < LruCache
    include SafeSync
  end
end
