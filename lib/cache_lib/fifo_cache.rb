module CacheLib
  class FifoCache < BasicCache
    def initialize(*args)
      limit, _ = args

      fail ArgumentError, "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      @cache = UtilHash.new
    end

    def limit=(args)
      limit, _ = args

      limit ||= @limit

      fail ArgumentError, "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      resize
    end

    alias_method :[], :lookup
    alias_method :[]=, :store
    alias_method :delete, :evict

    protected

    def resize
      @cache.pop_tail while @cache.size > @limit
    end

    def miss(key, value)
      @cache[key] = value

      @cache.pop_tail if @cache.size > @limit

      value
    end
  end
end
