# consumer_spec.rb

# Assumes that target message broker/server has a user called 'guest' with a password 'guest'
# and that it is running on 'localhost'.

# If this is not the case, please change the 'Bunny.new' call below to include
# the relevant arguments e.g. @b = Bunny.new(:user => 'john', :pass => 'doe', :host => 'foobar')

require 'spec_helper'

class MessageHandler
  attr_reader :messages
  
  def initialize
    @messages = []
  end
  
  def process(msg)
    @messages << msg
  end
  
end

module Bunny
  
  describe Consumer do

    describe ".consume" do

      it "subscribes to a queue bound to a direct exchange if type is nil or type is not 'fanout'" do
        # given
        q = Bunny.queue("consumer_queue")
        q.publish("hello")
        q.message_count.should == 1

        # when
        Bunny::Consumer.start("consumer_queue", MessageHandler.new, :timeout => 3)

        # expect
        q.message_count.should == 0
      end
      
      it "subscribes to a queue bound to a fanout exchange if type is 'fanout'" do
        # given
        opts = {
          :type => "fanout",
          :exch_name => "consumer_exchange"
        }
        handler1 = MessageHandler.new
        handler2 = MessageHandler.new

        [handler1, handler2].each_with_index do |handler, index|
          Thread.new do
            Bunny::Consumer.start("fanout_queue#{index + 1}", handler, opts)
          end
        end

        # when
        sleep 2
        Bunny.publish("consumer_exchange", "hello to all", :type => "fanout")

        # expect
        sleep 2
        [handler1, handler2].each {|h| h.messages.size.should == 1}
      end

    end

  end

end
