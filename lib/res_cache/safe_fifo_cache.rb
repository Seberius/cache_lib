require_relative 'safe_sync'

module ResCache
  class SafeFifoCache < FifoCache
    include SafeSync
  end
end
