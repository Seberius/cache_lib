module ResCache
  class LirsCache < BasicCache
    def initialize(*args)
      s_limit, q_limit = args

      fail ArgumentError 'S Limit must be 1 or greater.' if
          s_limit.nil? || s_limit < 1
      fail ArgumentError 'Q Limit must be 1 or greater.' if
          q_limit.nil? || q_limit < 1

      @s_limit = s_limit
      @q_limit = q_limit
      @limit = s_limit + q_limit

      @cache = UtilHash.new
      @stack = UtilHash.new
      @queue = UtilHash.new
    end

    def limit=(args)
      s_limit, q_limit = args

      fail ArgumentError 'S Limit must be 1 or greater.' if
          s_limit.nil? || s_limit < 1
      fail ArgumentError 'Q Limit must be 1 or greater.' if
          q_limit.nil? || q_limit < 1

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
      hit(key) if @cache.key?(key)
    end

    def evict(key)
      return unless @cache.key?(key)

      value = @cache.delete(key)

      if @queue.key?(key)
        @queue.delete(key)
      else
        promote_hir if @queue.size > 0

        trim_stack
      end

      value
    end

    def clear
      @cache.clear
      @stack.clear
      @queue.clear
    end

    def raw
      { cache: @cache.clone, stack: @stack.clone, queue: @queue.clone }
    end

    def priority
      lir_keys = []
      hir_keys = []

      @stack.each_key do |key|
        lir_keys.push(key) if @cache.key?(key) && !@queue.key?(key)
      end

      @queue.each_key do |key|
        hir_keys.push(key) unless @stack.key?(key)
      end

      hir_keys.concat(lir_keys).reverse!
    end

    alias_method :[], :lookup
    alias_method :[]=, :set

    protected

    def trim_stack
      s_tail = @stack.tail
      while @queue.key?(s_tail) || !@cache.key?(s_tail)
        @stack.delete(s_tail)
        s_tail = @stack.tail
      end
    end

    def promote_hir
      key = @queue.head

      @stack.set_tail(key, nil) unless @stack.key?(key)
      @queue.delete(key)
    end

    def pop_tail
      key = @queue.tail

      @queue.delete(key)
      @cache.delete(key)
    end

    def pop_stack
      key = @stack.tail

      @cache.delete(key)
      trim_stack
    end

    def demote_lir
      key = @stack.tail

      @stack.delete(key)
      @queue.set_head(key, nil)
      trim_stack
    end

    def resize
      s_size = 0

      @stack.each do |key, _|
        s_size += 1 if @cache.key?(key) && !@queue.key?(key)
      end

      promote_hir while (s_size < @s_limit && @queue.size > 0) && s_size += 1
      pop_tail while @queue.size > 0 && @cache.size > @limit
      pop_stack while @cache.size > @limit && s_size -= 1
      demote_lir while s_size > @s_limit && s_size -= 1
    end

    def hit(key)
      value = @cache[key]

      if @stack.key?(key)
        if @queue.key?(key)
          @stack.refresh(key)
          @queue.delete(key)

          demote_lir
        else
          old_s_key = @stack.tail
          @stack.refresh(key)

          trim_stack if old_s_key == key
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
        pop_tail if @queue.size >= @q_limit

        @cache[key] = value

        if @stack.key?(key)
          @stack.refresh(key)

          demote_lir
        else
          @stack.set_head(key, nil)
          @queue.set_head(key, nil)
        end
      end

      value
    end
  end
end
