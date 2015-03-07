require 'benchmark'
require 'lru'
require 'lru_cache'
require 'threadsafe-lru'
require 'lru_redux'
require 'fast_cache'
$LOAD_PATH.unshift File.expand_path '../lib'
require File.expand_path('../../lib/cache_lib', __FILE__)

# Lru
cache_lru = Cache::LRU.new(max_elements: 1_000)

# LruCache
lru_cache = LRUCache.new(1_000)

# ThreadSafeLru
thread_safe_lru = ThreadSafeLru::LruCache.new(1_000)

# LruRedux
lru_redux = LruRedux::Cache.new(1_000)
lru_redux_safe = LruRedux::ThreadSafeCache.new(1_000)

# FastCache
fast_cache = FastCache::Cache.new(1_000, 5 * 60)

# CacheLib
cache_lib_lru = CacheLib.create :lru, 1_000
cache_lib_lru_safe = CacheLib.safe_create :lru, 1_000
cache_lib_ttl = CacheLib.create :ttl, 1_000, 5 * 60
cache_lib_lirs = CacheLib.create :lirs, 950, 50

puts
puts "** LRU Benchmarks **"
Benchmark.bmbm do |bm|
  bm.report 'Lru' do
    1_000_000.times { cache_lru[rand(2_000)] ||= :value }
  end

  bm.report 'LruCache' do
    1_000_000.times { lru_cache[rand(2_000)] ||= :value }
  end

  bm.report 'LruRedux' do
    1_000_000.times { lru_redux.getset(rand(2_000)) { :value } }
  end

  bm.report 'CacheLib::LRU' do
    1_000_000.times { cache_lib_lru.get(rand(2_000)) { :value } }
  end
end

puts
puts "** LRU Thread Safe Benchmarks **"
Benchmark.bmbm do |bm|
  bm.report 'ThreadSafeLru' do
    1_000_000.times { thread_safe_lru.get(rand(2_000)) { :value } }
  end

  bm.report 'LruRedux Safe' do
    1_000_000.times { lru_redux_safe.getset(rand(2_000)) { :value } }
  end

  bm.report 'CacheLib::LRU Safe' do
    1_000_000.times { cache_lib_lru_safe.get(rand(2_000)) { :value } }
  end
end

puts
puts "** TTL Benchmarks **"
Benchmark.bmbm do |bm|
  bm.report 'FastCache' do
    1_000_000.times { fast_cache.fetch(rand(2_000)) { :value } }
  end

  bm.report 'CacheLib::TTL' do
    1_000_000.times { cache_lib_ttl.get(rand(2_000)) { :value } }
  end
end

puts
puts "** LIRS Benchmarks **"
Benchmark.bmbm do |bm|
  bm.report 'CacheLib::LIRS' do
    1_000_000.times { cache_lib_lirs.get(rand(2_000)) { :value } }
  end
end
