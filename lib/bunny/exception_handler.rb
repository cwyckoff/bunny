module Bunny

  class ExceptionHandler

    class << self
      def define
        yield self
      end

      def handle(action=:all, info={})
        begin
          yield
        rescue Exception => e
          handlers = handlers_for(action)
          raise e if handlers.empty?
          handlers.each { |h| h.handle(e, info) }
        end
      end
      
      def register(type, klass=nil, &block)
        handler = klass
        if block_given?
          def block.handle(*args)
            call(*args)
          end
          handler = block
        end
        handlers[type.to_sym] << handler
      end

      def reset
        @handlers = nil
      end
      
      def handlers
        @handlers ||= Hash.new { |h, k| h[k] = [] }
      end

      private

      def handlers_for(action)
        return handlers[:all] if action == :all
        handlers[action.to_sym] + handlers[:all]
      end

    end

  end

end
