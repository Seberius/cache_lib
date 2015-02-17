# CacheLib
#### A Ruby caching library implementing Basic, FIFO, LRU and LIRS caches.

## Usage
### Creating a cache
```ruby
require 'res_cache'

# Basic
cache = CacheLib.create :basic

# FIFO with a limit of 100
cache = CacheLib.create :fifo, 100

# LRU with a limit of 100
cache = CacheLib.create :lru, 100

# LIRS with a cache limit of 100, made up of a S limit of 95 and a Q limit of 5.
# Read the LIRS Cache section for more information.
cache = CacheLib.create :lirs, 95, 5
```

### Using the cache
```ruby
# Cache methods remain the same across all variations
cache = CacheLib.create :lru, 100

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

cache.key?(:a)
# => true
cache.key?(:g)
# => false

cache.to_a
# => [[:c, 'Chopin'], [:a, 'Mozart'], [:b, 'Beethoven']]

cache.size
# => 3

cache.clear
# => nil
```

## Copyright

Copyright (c) 2015 Kaijah Hougham

See [LICENSE.txt](LICENSE.txt) for details.
