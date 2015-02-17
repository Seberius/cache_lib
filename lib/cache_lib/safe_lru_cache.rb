require_relative 'safe_sync'

module CacheLib
  class SafeLruCache < LruCache
    include SafeSync
  end
end
