module CacheLib
  module LIRS
    class Cache < Basic::Cache
      def initialize(*args)
        s_limit, q_limit = args

        fail ArgumentError, "S Limit must be 1 or greater: #{s_limit}" unless
            s_limit && (s_limit.is_a? Numeric) && s_limit > 0
        fail ArgumentError, "Q Limit must be 1 or greater: #{q_limit}" unless
            q_limit && (q_limit.is_a? Numeric) && q_limit > 0

        @limit = s_limit + q_limit
        @ttl = nil
        @s_limit = s_limit
        @q_limit = q_limit

        @cache = Util::ExtHash.new
        @stack = Util::ExtHash.new
        @queue = Util::ExtHash.new
      end

      def initialize_copy(source)
        source_raw = source.raw

        @limit = source_raw[:limit]
        @ttl = source_raw[:ttl]
        @s_limit = source_raw[:s_limit]
        @q_limit = source_raw[:q_limit]

        @cache = source_raw[:cache]
        @stack = source_raw[:stack]
        @queue = source_raw[:queue]
      end

      def limit=(args)
        s_limit, q_limit = args

        fail ArgumentError, "S Limit must be 1 or greater: #{s_limit}" unless
            s_limit && (s_limit.is_a? Numeric) && s_limit > 0
        fail ArgumentError, "Q Limit must be 1 or greater: #{q_limit}" unless
            q_limit && (q_limit.is_a? Numeric) && q_limit > 0

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

      def store(key, value)
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

      def fetch(key)
        if @cache.key?(key)
          hit(key)
        else
          yield if block_given?
        end
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
        nil
      end

      def raw
        { limit: @limit,
          ttl: @ttl,
          s_limit: @s_limit,
          q_limit: @q_limit,
          cache: @cache.clone,
          stack: @stack.clone,
          queue: @queue.clone }
      end

      def to_s
        "#{self.class}, "\
        "Limit: #{@limit}, "\
        "Stack Limit: #{@s_limit}, "\
        "Queue Limit: #{@q_limit}, "\
        "Size: #{@cache.size}"
      end

      alias_method :[], :lookup
      alias_method :[]=, :store
      alias_method :delete, :evict

      protected

      def trim_stack
        key, _ = @stack.tail
        while key && (@queue.key?(key) || !@cache.key?(key))
          @stack.delete(key)
          key, _ = @stack.tail
        end
      end

      def promote_hir
        key = @queue.head_key

        @stack.set_tail(key, nil) unless @stack.key?(key)
        @queue.delete(key)
      end

      def pop_tail
        key, _ = @queue.tail

        @queue.delete(key)
        @cache.delete(key)
      end

      def pop_stack
        key, _ = @stack.tail

        @cache.delete(key)

        trim_stack
      end

      def demote_lir
        key, _ = @stack.tail

        @stack.delete(key)
        @queue.set_head(key, nil)

        trim_stack
      end

      def resize
        s_size = @stack.count { |key, _| @cache.key?(key) && !@queue.key?(key) }

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
            s_tail_key, _ = @stack.tail
            @stack.refresh(key)

            trim_stack if s_tail_key == key
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
end
