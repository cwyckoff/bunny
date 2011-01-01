module Bunny

  class Environment

    class << self
      attr_accessor :mode

      def define
        yield self
      end

      def options
        @options ||= {}
      end

      str = ''
      %w[host port vhost user pass ssl verify_ssl logfile logging logfile frame_max channel_max heartbeat connect_timeout].each do |method|
        str += <<-EOS
        def #{method}=(value)
          options[:#{method}] = value
        end
EOS
     end
     class_eval(str)

     def reset
       self.mode = nil
       @options = {}
     end
     
     def set?
       !options.empty?
     end
     
   end

 end
    
end
