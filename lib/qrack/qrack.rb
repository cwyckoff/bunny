$: << File.expand_path(File.dirname(__FILE__))

require 'protocol/spec'
require 'protocol/protocol'

require 'transport/buffer'
require 'transport/frame'

module Qrack
  
  include Protocol
  include Transport
  
  # Errors
  class BufferOverflowError < StandardError; end
  class InvalidTypeError < StandardError; end

end
