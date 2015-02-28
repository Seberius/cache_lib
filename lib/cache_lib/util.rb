require_relative 'util/ext_hash'
require_relative 'util/safe_sync'

require_relative 'util/safe_sync_jruby' if
    RUBY_PLATFORM == 'java' && JRUBY_VERSION < '9.0'