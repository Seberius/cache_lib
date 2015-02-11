require_relative 'rcache/util-hash'
require_relative 'rcache/basic-cache'
require_relative 'rcache/fifo-cache'
require_relative 'rcache/lru-cache'
require_relative 'rcache/lirs-cache'

module RCache
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

  def self.update(old_cache, type, *args)
    old_raw = old_cache.raw
    old_priority = old_cache.priority.reverse!
    new_cache = create(type, *args)

    old_priority.each {|key| new_cache.set(key, old_raw[key])}
    old_cache.clear

    new_cache
  end
end