# RCache
#### A Ruby caching library implementing Basic, FIFO, LRU and LIRS caching strategies.

## Usage
### Creating a cache
    require 'rcache'

    # Basic
    cache = RCache::Cache.new(:basic)

    # FIFO with a limit of 100
    cache = RCache::Cache.new(:fifo, 100)

    # LRU with a limit of 100
    cache = RCache::Cache.new(:lru, 100)

    # LIRS with a cache limit of 100, made up of a S limit of 95 and a Q limit of 5.
    # Read the LIRS Cache section for more information.
    cache = RCache::Cache.new(:lirs, 95, 5)

### Using the cache
    # Cache methods remain the same across all variations
    cache = RCache::Cache.new(:lru, 100)

    cache.get(:a) { 'Apple' }
    # => 'Apple'
    cache.get(:b) { 'Beethoven' }
    # => 'Beethoven'
    cache.get(:a) { 'Apricot' }
    # => 'Apple'

    cache.set(:c, 'Chopin')
    # => 'Chopin'
    cache.set(:a, 'Mozart')
    # => 'Mozart'

    cache[:d] = 'Denmark'
    # => 'Denmark'

    cache.lookup(:c)
    # => 'Chopin'
    cache.lookup(:t)
    # => nil

    cache[:a]
    # => 'Mozart'

    cache.evict(:d)
    # => 'Denmark'
    cache.evict(:r)
    # => nil

    cache.has_key?(:a)
    # => true
    cache.has_key?(:g)
    # => false

    cache.to_a
    # => [[:a, 'Mozart'], [:c, 'Chopin'], [:b, 'Beethoven']]

    cache.size
    # => 3

    cache.clear
    # => nil

## Copyright

Copyright (c) 2015 Kaijah Hougham

See [LICENSE.txt](LICENSE.txt) for details.

