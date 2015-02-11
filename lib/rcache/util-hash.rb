module RCache
  class UtilHash < Hash
    def get_head
      keys.last
    end

    def get_tail
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