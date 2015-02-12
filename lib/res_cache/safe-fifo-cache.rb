require 'monitor'

module ResCache
  class SafeFifoCache < FifoCache
    include MonitorMixin

    def initialize(*args)
      super(*args)
    end

    def limit
      synchronize do
        super
      end
    end

    def limit=(*args)
      synchronize do
        super(*args)
      end
    end

    def get(key)
      synchronize do
        super(key)
      end
    end

    def set(key, value)
      synchronize do
        super(key, value)
      end
    end

    def lookup(key)
      synchronize do
        super(key)
      end
    end

    def evict(key)
      synchronize do
        super(key)
      end
    end

    def clear
      synchronize do
        super
      end
    end

    def key?(key)
      synchronize do
        super(key)
      end
    end

    def to_a
      synchronize do
        super
      end
    end

    def size
      synchronize do
        super
      end
    end

    def raw
      synchronize do
        super
      end
    end

    def priority
      synchronize do
        super
      end
    end

    alias_method :[], :lookup
    alias_method :[]=, :set
  end
end