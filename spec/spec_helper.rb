$LOAD_PATH.unshift(File.dirname(__FILE__) + "/..")

require 'lib/bunny'
require 'lib/bunny/filter'
require 'lib/bunny/environment'
require 'lib/bunny/exception_handler'
require 'rspec'

# %w[qrack bunny].each do |dir|
#   Dir[File.join("lib", dir, "**/*.rb")].each { |file| require file }
# end

# Bunny::Environment.define do |e|
#   e.mode = :test
# end

class Bunny::FakeClient

  def start; end
  def stop; end
  def ack(*args); self; end
  def bind(*args); self; end
  def exchange(*args); self; end
  def queue(*args); self; end
  def publish(*args); self; end
  def pop(*args); {:payload => nil}; end
  def subscribe(*args)
    yield if block_given?
  end
  
end


