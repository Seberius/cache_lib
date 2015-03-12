# CacheLib [![Gem Version](https://badge.fury.io/rb/cache_lib.svg)](http://badge.fury.io/rb/cache_lib) [![Dependency Status](https://gemnasium.com/Seberius/cache_lib.svg)](https://gemnasium.com/Seberius/cache_lib)
[![Build Status](https://travis-ci.org/Seberius/cache_lib.svg?branch=master)](https://travis-ci.org/Seberius/cache_lib)
[![Code Climate](https://codeclimate.com/github/Seberius/cache_lib/badges/gpa.svg)](https://codeclimate.com/github/Seberius/cache_lib)
[![Test Coverage](https://codeclimate.com/github/Seberius/cache_lib/badges/coverage.svg)](https://codeclimate.com/github/Seberius/cache_lib)
#### A Ruby caching library implementing Basic, FIFO, LRU, TTL and LIRS caches.

##### CacheLib is young library and breaking api changes are still possible.  Please read the release notes before upgrading.
CacheLib currently implements basic, FIFO, LRU and LIRS caches along with offering thread safe implementations of each.  Originally a LIRS cache feature fork of [LruRedux](https://github.com/SamSaffron/lru_redux), CacheLib was built to provide a clean base for implementing the LIRS cache in Ruby, along with offering a user friendly api.

##### Basic:
The basic cache is the simplest cache available and forms the base for the others.  It does NOT have an eviction strategy and will store however much it is given.

##### FIFO:
The FIFO cache adds to the basic cache with a simple First In First Our eviction strategy to limit the cache size to a user set limit.

##### LRU:
The LRU cache further adds to the previous caches with a Least Recently Used eviction strategy.  The primary difference between FIFO and LRU is that LRU will refresh currently cached items if they are requested again.

##### TTL:
The TTL cache is an extension of the LRU cache, adding a TTL eviction strategy that takes precedence over LRU eviction.

##### LIRS:
The LIRS cache implements the Low Inter-Reference Recency Set eviction policy.  LIRS improves performance over LRU by taking into account the recency and reuse of an item in eviction selection. Please reference the [original paper](http://citeseer.ist.psu.edu/viewdoc/summary?doi=10.1.1.116.2184) for more information.

##### CacheLib is Ruby >= 1.9.3 only.
If you are looking for a LRU cache that supports an earlier version or just want an alternative LRU cache, please take a look at [LruRedux](https://github.com/SamSaffron/lru_redux).

## Usage
### Creating
```ruby
require 'cache_lib'
```
CacheLib#create is module method that will return an object of the class and settings of the arguments passed to it.  The class can also be instantiated directly with #new.

##### Basic cache
```ruby
cache = CacheLib.create :basic
cache = CacheLib::Basic::Cache.new
# Thread safe
cache = CacheLib.safe_create :basic
cache = CacheLib::Basic::SafeCache.new
```
##### FIFO cache with limit of 100
```ruby
cache = CacheLib.create :fifo, 100
cache = CacheLib::FIFO::Cache.new(100)
# Thread safe
cache = CacheLib.safe_create :fifo, 100
cache = CacheLib::FIFO::SafeCache.new(100)
```
##### LRU cache with limit of 100
```ruby
cache = CacheLib.create :lru, 100
cache = CacheLib::LRU::Cache.new(100)
# Thread safe
cache = CacheLib.safe_create :lru, 100
cache = CacheLib::LRU::SafeCache.new(100)
```
##### TTL cache with limit of 100 and ttl of 5 minutes
```ruby
cache = CacheLib.create :ttl, 100, 5 * 60
cache = CacheLib::TTL::Cache.new(100, 5 * 60)
# Thread safe
cache = CacheLib.safe_create :ttl, 100, 5 * 60
cache = CacheLib::TTL::SafeCache.new(100, 5 * 60)
```
##### LIRS cache with limit of 100 (stack limit of 95, queue limit of 5)
```ruby
cache = CacheLib.create :lirs, 95, 5
cache = CacheLib::LIRS::Cache.new(95, 5)
# Thread safe
cache = CacheLib.safe_create :lirs, 95, 5
cache = CacheLib::LIRS::SafeCache.new(95, 5)
```

### Using the cache.
##### #get
```ruby
# #get is the primary method for accessing the cache.
# It requires a key and block that will generate the value that is stored
# if the key is not cached.
cache.get(:a) { 'Apple' }
# => 'Apple'
cache.get(:b) { 'Beethoven' }
# => 'Beethoven'
cache.get(:a) { 'Apricot' }
# => 'Apple'
```
##### #store and []=
```ruby
# #store takes a key and value and implements the functionality of Hash#store.
# Will refresh key priority in LRU, TTL and LIRS caches.
cache.store(:c, 'Chopin')
# => 'Chopin'
cache.store(:a, 'Mozart')
# => 'Mozart'

# []= is equivalent to #store.
cache[:d] = 'Denmark'
# => 'Denmark'
```
##### #lookup and []
```ruby
# #lookup takes a key and returns either the value if the key is cached or nil if it is not.
# Will refresh key priority in LRU, TTL and LIRS caches.
cache.lookup(:c)
# => 'Chopin'
cache.lookup(:t)
# => nil

# [] is equivalent to .lookup.
cache[:a]
# => 'Mozart'
```
##### #fetch
```ruby
# #fetch is similar to #lookup,
# but takes an optional block that will execute if the key is not cached.
cache.fetch(:c)
# => 'Chopin'
cache.fetch(:r) { 21 * 2 }
# => 42
```
##### #peek
```ruby
# #peek is similar to lookup but will NOT refresh the key priority.
cache.peek(:c)
# => 'Chopin'
cache.peek(:t)
# => nil
```
##### #swap
```ruby
# #swap will replace a value on a currently cached key.
# Returns nil if the key is currently not cached.
cache.swap(:c, 'Chopin')
# => 'Chopin'
cache.swap(:w, 'Mozart')
# => nil
```
##### #evict (#delete).
```ruby
# #evict takes a key and will remove the key from the cache and return the associated value.
# Returns nil is the key is not cached.
cache.evict(:d)
# => 'Denmark'
cache.evict(:r)
# => nil

# ALIAS: #delete
```

##### #each
```ruby
# .each takes each key value pair and applies the given block to them.
cache.each { |_, value| puts value }
# => 'Chopin'
# => 'Mozart'
# => 'Beethoven'
```

##### #key? (#has_key?, #member?)
```ruby
# .key? takes a key and returns true if it is cached and false if it is not.
cache.key?(:a)
# => true
cache.key?(:g)
# => false

# ALIAS: #has_key? and #member?
```

##### #to_a
```ruby
# #to_a returns an array of arrays of key value pairs that are cached.
# Basic, FIFO and LIRS are insertion ordered while LRU and TTL are recency ordered,
# starting with the newest.
cache.to_a
# => [[:c, 'Chopin'], [:a, 'Mozart'], [:b, 'Beethoven']]
```

##### #keys and #values
```ruby
# #keys returns an array of the keys that are cached.
cache.keys
# => [:c, :a, :b]

# #values returns an array of the values that are cached.
cache.values
# => ['Chopin', 'Mozart', 'Beethoven']
```

##### #size (#length)
```ruby
# #size returns the current number of items that are cached.
cache.size
# => 3

# ALIAS: #length
```

##### #count
```ruby
# #count functions like the Hash#count.
cache.count { |_, value| value == 'Chopin' }
# => 1
```

##### #expire
```ruby
# #expire will trigger a ttl based eviction in caches which make use of ttl
cache.expire
# => nil
```

##### #raw
```ruby
# #raw returns clone of the internal
```

### Cache settings
Every cache shares the same api, but a setting may not be used in some caches.
```ruby
# e.g.
cache = CacheLib.create :lirs, 95, 5
# LIRS cache does not use a ttl, so the value is discarded and nil is returned.
cache.ttl = 6 * 60
# => nil
```

#### Limit
A limit change will trigger pruning of the lowest priority (e.g. least recently accessed in LRU) items if the current cache size is larger than the new limit.
```ruby
# Basic (does not use limit)
cache.limit = 90
# => nil

# FIFO, LRU and TTL
cache.limit = 90
# => 90

# LIRS
cache.limit = 85, 5
# => [85, 5]
```

#### TTL
A ttl change will trigger the eviction of items that are considered expired under the new ttl.
```ruby
# Basic, FIFO, LRU and LIRS (does not use ttl)
cache.ttl = 6 * 60
# => nil

# TTL
cache.ttl = 6 * 60
# => 360
```

## Benchmark
Ruby 2.2.0
`rake benchmark`
```
** LRU Benchmarks **
Rehearsal -------------------------------------------------
Lru             2.210000   0.010000   2.220000 (  2.230479)
LruCache        1.700000   0.000000   1.700000 (  1.696180)
LruRedux        1.180000   0.000000   1.180000 (  1.182591)
CacheLib::LRU   1.040000   0.010000   1.050000 (  1.042496)
---------------------------------------- total: 6.150000sec

                    user     system      total        real
Lru             2.230000   0.010000   2.240000 (  2.234959)
LruCache        1.670000   0.000000   1.670000 (  1.668350)
LruRedux        1.180000   0.000000   1.180000 (  1.176366)
CacheLib::LRU   1.070000   0.000000   1.070000 (  1.071050)

** LRU Thread Safe Benchmarks **
Rehearsal ------------------------------------------------------
ThreadSafeLru        4.730000   0.020000   4.750000 (  4.751917)
LruRedux Safe        2.640000   0.000000   2.640000 (  2.644138)
CacheLib::LRU Safe   2.540000   0.010000   2.550000 (  2.549686)
--------------------------------------------- total: 9.940000sec

                         user     system      total        real
ThreadSafeLru        4.740000   0.020000   4.760000 (  4.759914)
LruRedux Safe        2.620000   0.000000   2.620000 (  2.623149)
CacheLib::LRU Safe   2.440000   0.000000   2.440000 (  2.440539)

** TTL Benchmarks **
Rehearsal -------------------------------------------------
FastCache       5.840000   0.050000   5.890000 (  5.891199)
CacheLib::TTL   5.830000   0.050000   5.880000 (  5.908800)
--------------------------------------- total: 11.770000sec

                    user     system      total        real
FastCache       6.300000   0.030000   6.330000 (  6.328788)
CacheLib::TTL   5.760000   0.050000   5.810000 (  5.841070)

** LIRS Benchmarks **
Rehearsal --------------------------------------------------
CacheLib::LIRS   3.520000   0.010000   3.530000 (  3.527982)
----------------------------------------- total: 3.530000sec

                     user     system      total        real
CacheLib::LIRS   3.470000   0.010000   3.480000 (  3.478695)
```

## Credits and Notices
See [NOTICE.md](NOTICE.md) for details.

## Copyright
Copyright (c) 2015 Kaijah Hougham

See [LICENSE.txt](LICENSE.txt) for details.
