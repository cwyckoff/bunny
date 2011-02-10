$LOAD_PATH.unshift(File.dirname(__FILE__) + "/..")

require 'lib/bunny'
require 'lib/bunny/fake_client'
require 'rspec'

Bunny.logger = Bunny::Logger.new('spec/bunny.log')
