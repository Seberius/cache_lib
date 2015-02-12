# -*- encoding: utf-8 -*-

require File.expand_path('../lib/res_cache/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'res_cache'
  gem.version       = ResCache::VERSION
  gem.summary       = %q{A Ruby Caching Library}
  gem.description   = %q{A Ruby caching library implementing Basic, FIFO, LRU and LIRS caching strategies.}
  gem.license       = 'MIT'
  gem.authors       = 'Kaijah Hougham'
  gem.email         = 'github@seberius.com'
  gem.homepage      = 'https://github.com/seberius/res_cache'

  gem.required_ruby_version = '>= 1.9.3'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.7'
  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'minitest', '~> 5.0'
end