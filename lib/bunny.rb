$:.unshift File.expand_path(File.dirname(__FILE__))

require 'bunny/logger'
require 'bunny/filter'
require 'bunny/environment'
require 'bunny/exception_handler'
require 'bunny/consumer'

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
  
  VERSION = '0.7.1'
  
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

  def self.delete_queue(name, opts={})
    run { |b| b.queue(name).delete }
  end
  
  def self.exchange(name, opts={})
    bunny = Bunny.new
    bunny.start
    bunny.exchange(name, opts)
  end
  
  def self.fanout_queue(exchange_name, queue_name)
    exch = Bunny.exchange(exchange_name, :type => "fanout")
    queue = Bunny.queue(queue_name)
    queue.bind(exch)
    queue
  end
  
  def self.queue(name, opts={})
    bunny = Bunny.new
    bunny.start
    bunny.queue(name, opts)
  end

  def self.publish(name, msg, opts={})
    run do |bunny|
      if opts[:type] && opts[:type] == "fanout"
        exch = bunny.exchange(name, opts.merge(:type => "fanout"))
        exch.publish(msg)
      else
        queue = bunny.queue(name, opts.merge(:type => "direct"))
        queue.publish(msg)
      end
    end
  end
  
  # Runs a code block using a short-lived connection
  def self.run(opts = {}, &block)
    raise ArgumentError, 'Bunny#run requires a block' unless block
    bunny = Bunny.new(opts)
    
    begin
      bunny.start
      block.call(bunny)
    ensure
      bunny.stop
    end

    # Return success
    :run_ok
  end

  private
  
  def self.setup(opts)	
    # uses the AMQP 0-9-1 specification
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
