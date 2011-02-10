require 'logger'

module Bunny

  class MissingLogger < ::StandardError; end

  def self.logger=(new_logger)
    @logger = new_logger
  end

  def self.logger
    return @logger if @logger
    raise MissingLogger, "No logger has been set for Bunny.  Please define one with Bunny.logger=."
  end

  def self.log_mode=(mode)
    @log_mode = mode
  end

  def self.log_mode
    @log_mode || "info"
  end
  
  class Logger < ::Logger

    def format_message(severity, timestamp, progname, msg)
      "[#{timestamp.strftime("%Y-%m-%d %H:%M:%S %z")}] #{severity} -- : #{msg}\n"
    end

    def wrap(data, wrapper="=", limit=100, level="info")
      send(level, wrapper * limit.to_i)
      send(level, data)
      send(level, wrapper * limit.to_i)
    end

  end
end
