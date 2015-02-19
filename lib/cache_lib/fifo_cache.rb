module CacheLib
  class FifoCache < BasicCache
    def initialize(*args)
      limit, _ = args

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      @cache = UtilHash.new
    end

    def limit=(args)
      limit, _ = args

      limit ||= @limit

      fail ArgumentError "Cache Limit must be 1 or greater: #{limit}" if
          limit.nil? || limit < 1

      @limit = limit

      resize
    end

    def inspect
      "#{self.class} with a limit of #{@limit} "\
      "currently caching #{@cache.size} items."
    end

    alias_method :[], :lookup
    alias_method :[]=, :store

    protected

    def resize
      @cache.delete(@cache.tail) while @cache.size > @limit
    end

    def miss(key, value)
      @cache[key] = value

      @cache.pop_tail if @cache.size > @limit

      value
    end
  end
end
