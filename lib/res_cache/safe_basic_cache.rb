require_relative 'safe_sync'

module ResCache
  class SafeBasicCache < BasicCache
    include SafeSync
  end
end
