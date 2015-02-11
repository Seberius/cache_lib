# -*- encoding: utf-8 -*-

require File.expand_path("../lib/rcache/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "rcache"
  gem.version       = RCache::VERSION
  gem.summary       = %q{A Ruby Caching Library}
  gem.description   = %q{A Ruby caching library implementing Basic, FIFO, LRU and LIRS caching strategies.}
  gem.license       = "MIT"
  gem.authors       = "Kaijah Hougham"
  gem.email         = "github@seberius.com"
  gem.homepage      = "https://github.com/seberius/rcache"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency 'lru_redux'
end