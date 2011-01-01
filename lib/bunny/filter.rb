module Bunny

  class Filter

    def self.define
      yield self
    end

    def self.reset
      @filter_actions = {}
    end

    def self.on_publish(&block)
      filter_actions[:publish] = block
    end
    
    def self.on_consume(&block)
      filter_actions[:consume] = block
    end

    def self.filter(action, msg)
      if filter_actions[action.to_sym]
        filter_actions[action.to_sym].call(msg)
      else
        msg
      end
    end

    def self.filter_actions
      @filter_actions ||= {}
    end

  end

end
