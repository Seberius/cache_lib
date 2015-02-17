require_relative 'safe_sync'

module CacheLib
  class SafeBasicCache < BasicCache
    include SafeSync
  end
end
