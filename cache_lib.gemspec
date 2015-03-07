# -*- encoding: utf-8 -*-

require File.expand_path('../lib/cache_lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'cache_lib'
  gem.version       = CacheLib::VERSION
  gem.summary       = 'A Ruby Caching Library'
  gem.description   = 'A Ruby caching library implementing Basic, FIFO, LRU, TTL and LIRS caches.'
  gem.license       = 'MIT'
  gem.authors       = 'Kaijah Hougham'
  gem.email         = 'github@seberius.com'
  gem.homepage      = 'https://github.com/seberius/cache_lib'

  gem.required_ruby_version = '>= 1.9.3'

  gem.files         = `git ls-files`.split($RS)
  gem.executables   = gem.files.grep(/bin/).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/test/)
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '~> 10'

  # Testing
  gem.add_development_dependency 'minitest', '~> 5.5'
  gem.add_development_dependency 'timecop', '~> 0.7'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'

  # Benchmarks
  gem.add_development_dependency 'lru'
  gem.add_development_dependency 'lru_cache'
  gem.add_development_dependency 'threadsafe-lru'
  gem.add_development_dependency 'lru_redux'
  gem.add_development_dependency 'fast_cache'
end
