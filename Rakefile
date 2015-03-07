require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.test_files = FileList['test/**/test*.rb']
  test.verbose = true
end

task :benchmark do
  ruby 'benchmarks/benchmark.rb'
end

task default: :test
