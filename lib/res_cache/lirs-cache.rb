module ResCache
  class LirsCache

    attr_reader :limit

    def initialize(*args)
      s_limit, q_limit = args
      
      raise ArgumentError.new('S Limit must be 1 or greater.') if s_limit.nil? || s_limit < 1
      raise ArgumentError.new('Q Limit must be 1 or greater.') if q_limit.nil? || q_limit < 1

      @s_limit = s_limit
      @q_limit = q_limit
      @limit = s_limit + q_limit

      @cache = UtilHash.new
      @stack = UtilHash.new
      @queue = UtilHash.new
    end

    def limit=(args)
      s_limit, q_limit = args
      
      raise ArgumentError.new('S Limit must be 1 or greater.') if s_limit.nil? || s_limit < 1
      raise ArgumentError.new('Q Limit must be 1 or greater.') if q_limit.nil? || q_limit < 1

      @s_limit = s_limit
      @q_limit = q_limit
      @limit = s_limit + q_limit

      resize
    end

    def get(key)
      if @cache.key?(key)
        hit(key)
      else
        miss(key, yield)
      end
    end

    def set(key, value)
      if @cache.key?(key)
        @cache[key] = value
        hit(key)
      else
        miss(key, value)
      end
    end

    def lookup(key)
      if @cache.key?(key)
        hit(key)
      else
        nil
      end
    end

    def evict(key)
      if @cache.key?(key)
        value = @cache.delete(key)

        if @queue.key?(key)
          @queue.delete(key)
        elsif @queue.size > 0
          q_head_key = @cache.get_head
          @queue.delete(q_head_key)

          unless @stack.key?(q_head_key)
            @stack.set_tail(q_head_key, nil)
          end
        end

        trim_history

        value
      end
    end

    def clear
      @cache.clear
      @stack.clear
      @queue.clear
    end

    def key?(key)
      @cache.key?(key)
    end

    def to_a
      @cache.to_a.reverse!
    end

    def size
      @cache.size
    end

    def raw
      {cache: @cache.clone, stack: @stack.clone, queue: @queue.clone}
    end

    def priority
      lir_keys = []
      hir_keys = []

      @stack.each_key {|key| lir_keys.push(key) if @cache.has_key?(key) && !@queue.has_key?(key)}
      @queue.each_key {|key| hir_keys.push(key) unless @stack.has_key?(key)}

      hir_keys.concat(lir_keys).reverse!
    end

    alias_method :[], :lookup
    alias_method :[]=, :set

    protected

    def trim_history
      s_tail = @stack.get_tail
      while @queue.key?(s_tail) || !@cache.key?(s_tail) do
        @stack.delete(s_tail)
        s_tail = @stack.get_tail
      end
    end
    
    def resize
      s_size = 0

      @stack.each do |key, _|
        s_size += 1 if @cache.has_key?(key) && !@queue.has_key?(key)
      end

      while s_size < @s_limit && @queue.size > 0
        key = @queue.get_head

        unless @stack.has_key?(key)
          @stack.set_tail(key, nil)
        end

        @queue.delete(key)

        s_size += 1
      end

      while @queue.size > 0 && @cache.size > @limit
        key = @queue.get_tail

        @queue.delete(key)
        @cache.delete(key)
      end

      while @cache.size > @limit
        key = @stack.get_tail

        @cache.delete(key)
        trim_history

        s_size -= 1
      end

      while s_size > @s_limit
        key = @stack.get_tail

        @stack.delete(key)
        @queue.set_head(key, nil)
        trim_history

        s_size -= 1
      end
    end

    def hit(key)
      value = @cache[key]

      if @stack.key?(key)
        if @queue.key?(key)
          @stack.refresh(key)
          @queue.delete(key)

          old_s_key = @stack.get_tail
          @stack.delete(old_s_key)
          @queue.set_head(old_s_key, nil)

          trim_history
        else
          old_s_key = @stack.get_tail
          @stack.refresh(key)

          trim_history if old_s_key == key
        end
      else
        @stack.set_head(key, nil)
        @queue.refresh(key)
      end

      value
    end

    def miss(key, value)
      if @cache.size < @s_limit
        @cache[key] = value
        @stack.set_head(key, nil)
      else
        if @queue.size >= @q_limit
          old_q_key = @queue.get_tail
          @cache.delete(old_q_key)
          @queue.delete(old_q_key)
        end

        @cache[key] = value

        if @stack.key?(key)
          @stack.refresh(key)

          old_s_key = @stack.get_tail
          @stack.delete(old_s_key)
          @queue.set_head(old_s_key, nil)

          trim_history
        else
          @stack.set_head(key, nil)
          @queue.set_head(key, nil)
        end
      end

      value
    end
  end
end