# CacheLib
#### A Ruby caching library implementing Basic, FIFO, LRU and LIRS caches.

##### CacheLib is young library and breaking api changes are still possible.  Please read the release notes before upgrading.
CacheLib currently implements basic, FIFO, LRU and LIRS caches along with offering thread safe implementations of each.  Originally a LIRS cache feature fork of [LruRedux](https://github.com/SamSaffron/lru_redux), CacheLib was built to provide a clean base for implementing the LIRS cache in Ruby, along with offering user friendly api.

##### Basic:
The basic cache is the simplest cache available and forms the base for the others.  It does NOT have an eviction strategy and will store however much it is given.

##### FIFO:
The FIFO cache adds to the basic cache with a simple First In First Our eviction strategy to limit the cache size to a user set limit.

##### LRU:
The LRU cache further adds to the previous caches with a Least Recently Used eviction strategy.  The primary difference between FIFO and LRU is that LRU will refresh currently cached items if they are requested again.

##### LIRS:
The LIRS cache implements the Low Inter-Reference Recency Set Replacement Policy developed by Song Jiang and Xiaodong Zhang.  Please reference the [original paper](http://citeseer.ist.psu.edu/viewdoc/summary?doi=10.1.1.116.2184) for more information.

##### CacheLib is Ruby >= 1.9.3 only.
If you are looking for a LRU cache that supports an earlier version or just want an alternative LRU cache, please take a look at [LruRedux](https://github.com/SamSaffron/lru_redux).

## Usage
### Creating a cache
```ruby
require 'cache_lib'

# Basic
cache = CacheLib.create :basic

# FIFO with a limit of 100
cache = CacheLib.create :fifo, 100

# LRU with a limit of 100
cache = CacheLib.create :lru, 100

# LIRS with a cache limit of 100, made up of a S limit of 95 and a Q limit of 5.
cache = CacheLib.create :lirs, 95, 5
```

### Using the cache
```ruby
# Cache methods remain the same across all variations
cache = CacheLib.create :lru, 100

# .get is the primary method for accessing the cache.  It requires a key and block that will generate the value that is stored if the key is not cached.
cache.get(:a) { 'Apple' }
# => 'Apple'
cache.get(:b) { 'Beethoven' }
# => 'Beethoven'
cache.get(:a) { 'Apricot' }
# => 'Apple'

# .store takes a key and value and implements the functionality of Hash#store. Will refresh the key in LRU and LIRS caches.
cache.store(:c, 'Chopin')
# => 'Chopin'
cache.store(:a, 'Mozart')
# => 'Mozart'

# []= is equivalent to .store.
cache[:d] = 'Denmark'
# => 'Denmark'

# .lookup takes a key and returns either the value if the key is cached or nil if it is not.
cache.lookup(:c)
# => 'Chopin'
cache.lookup(:t)
# => nil

# [] is equivalent to .lookup.
cache[:a]
# => 'Mozart'

# .fetch is similar to .lookup, but takes an optional block that will execute if the key is not cached.
cache.fetch(:c)
# => 'Chopin'
cache.fetch(:r) { 21 * 2 }
# => 42

# .evict takes a key and will remove the key from the cache and return the associated value.  Returns nil is the key is not cached.
cache.evict(:d)
# => 'Denmark'
cache.evict(:r)
# => nil

# .each takes each key value pair and applies the given block to them.
cache.each { |_, value| puts value }
# => 'Chopin'
# => 'Mozart'
# => 'Beethoven'

# .key? takes a key and returns true if it is cached and false if it is not.
cache.key?(:a)
# => true
cache.key?(:g)
# => false

# .to_a returns an array of arrays of key value pairs that are cached.  Basic, FIFO and LIRS are insertion ordered while LRU is recency ordered, starting with newest.
cache.to_a
# => [[:c, 'Chopin'], [:a, 'Mozart'], [:b, 'Beethoven']]

# .keys returns an array of the keys that are cached.
cache.keys
# => [:c, :a, :b]

# .values returns an array of the values that are cached.
cache.values
# => ['Chopin', 'Mozart', 'Beethoven']

# .size returns the current number of items that are cached.
cache.size
# => 3

# .clear removes all items from the cache.
cache.clear
# => nil
```

## Copyright

Copyright (c) 2015 Kaijah Hougham

See [LICENSE.txt](LICENSE.txt) for details.
