module CacheLib
  class UtilHash < Hash
    def head
      keys.last
    end

    def tail
      first[0]
    end

    def set_head(key, value)
      delete(key)
      self[key] = value
    end

    def set_tail(key, value)
      replace(Hash[key, value].merge(self))
    end

    def refresh(key)
      value = delete(key)
      self[key] = value
    end
  end
end
