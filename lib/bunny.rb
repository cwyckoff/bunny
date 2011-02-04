$:.unshift File.expand_path(File.dirname(__FILE__))

require 'bunny/logger'
require 'bunny/filter'
require 'bunny/environment'
require 'bunny/exception_handler'

# Ruby standard libraries
%w[socket thread timeout logger].each do |file|
  require file
end

module Bunny

  class ConnectionError < StandardError; end
  class ForcedChannelCloseError < StandardError; end
  class ForcedConnectionCloseError < StandardError; end
  class MessageError < StandardError; end
  class ProtocolError < StandardError; end
  class ServerDownError < StandardError; end
  class UnsubscribeError < StandardError; end
  class AcknowledgementError < StandardError; end
  
  VERSION = '0.6.0'
  
  # Returns the Bunny version number
  def self.version
    VERSION
  end
  
  # Instantiates new Bunny::Client
  def self.new(opts = {})
    # Return client
    if Environment.mode == :test
      FakeClient.new
    elsif Environment.set?
      setup(Environment.options.merge(opts))
    else
      setup(opts)
    end
  end

  def self.client(opts={})
    Bunny.new(opts)
  end
  
  def self.exchange(name, opts={})
    bunny = Bunny.new
    bunny.start
    bunny.exchange(name, opts)
  end
  
  def self.queue(name, opts={})
    bunny = Bunny.new
    bunny.start
    bunny.queue(name, opts)
  end
  
  def self.publish(queue_name, msg, opts={})
    Bunny.queue(queue_name, opts).publish(msg)
  end
  
  # Runs a code block using a short-lived connection
  def self.run(opts = {}, &block)
    raise ArgumentError, 'Bunny#run requires a block' unless block
    client = setup(opts)
    
    begin
      client.start
      block.call(client)
    ensure
      client.stop
    end

    # Return success
    :run_ok
  end

  private
  
  def self.setup(opts)	
    # AMQP 0-9-1 specification
    require 'qrack/qrack'
    require 'bunny/client'
    require 'bunny/exchange'
    require 'bunny/queue'
    require 'bunny/channel'
    require 'bunny/subscription'

    client = Bunny::Client.new(opts)
    include Qrack

    client
  end

end
