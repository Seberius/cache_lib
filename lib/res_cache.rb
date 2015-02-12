require_relative 'res_cache/util-hash'
require_relative 'res_cache/basic-cache'
require_relative 'res_cache/fifo-cache'
require_relative 'res_cache/lru-cache'
require_relative 'res_cache/lirs-cache'
require_relative 'res_cache/safe-basic-cache'
require_relative 'res_cache/safe-fifo-cache'
require_relative 'res_cache/safe-lru-cache'
require_relative 'res_cache/safe-lirs-cache'
require_relative 'res_cache/version'

module ResCache
  def self.create(type, *args)
    case type
      when :basic
        BasicCache.new(*args)
      when :fifo
        FifoCache.new(*args)
      when :lru
        LruCache.new(*args)
      when :lirs
        LirsCache.new(*args)
      else
        raise ArgumentError.new("Cache type not recognized: #{type}")
    end
  end

  def self.safe_create(type, *args)
    case type
      when :basic
        SafeBasicCache.new(*args)
      when :fifo
        SafeFifoCache.new(*args)
      when :lru
        SafeLruCache.new(*args)
      when :lirs
        SafeLirsCache.new(*args)
      else
        raise ArgumentError.new("Cache type not recognized: #{type}")
    end
  end

  def self.update(old_cache, type, *args)
    new_cache = create(type, *args)

    old_raw = old_cache.raw[:cache]
    old_priority = old_cache.priority.reverse!
    old_priority.each {|key| new_cache.set(key, old_raw[key])}
    old_cache.clear

    new_cache
  end

  def self.safe_update(old_cache, type, *args)
    new_cache = safe_create(type, *args)

    old_raw = old_cache.raw[:cache]
    old_priority = old_cache.priority.reverse!
    old_priority.each {|key| new_cache.set(key, old_raw[key])}
    old_cache.clear

    new_cache
  end
end