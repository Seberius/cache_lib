require_relative 'util/ext_hash'
require_relative 'util/safe_sync'

# Ruby versions pre-2.1 have will have degraded performance with Hash#shift.
# https://bugs.ruby-lang.org/issues/8312
require_relative 'util/ext_hash_legacy' if
    RUBY_VERSION < '2.1.0'

# JRuby 1.7 behaves differently than the MRI when a block
# is passed to a method with super that takes arguments.
require_relative 'util/safe_sync_jruby' if
    RUBY_PLATFORM == 'java' && JRUBY_VERSION < '9.0'
