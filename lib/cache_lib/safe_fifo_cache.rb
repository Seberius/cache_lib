require_relative 'safe_sync'

module CacheLib
  class SafeFifoCache < FifoCache
    include SafeSync
  end
end
