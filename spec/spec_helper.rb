$LOAD_PATH.unshift(File.dirname(__FILE__) + "/..")

require 'lib/bunny'
require 'lib/bunny/fake_client'
require 'rspec'

# %w[qrack bunny].each do |dir|
#   Dir[File.join("lib", dir, "**/*.rb")].each { |file| require file }
# end

BunnyLogger = Logger.new(STDOUT)
