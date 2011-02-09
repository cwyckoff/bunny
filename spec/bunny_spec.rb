# bunny_spec.rb

# Assumes that target message broker/server has a user called 'guest' with a password 'guest'
# and that it is running on 'localhost'.

# If this is not the case, please change the 'Bunny.new' call below to include
# the relevant arguments e.g. @b = Bunny.new(:user => 'john', :pass => 'doe', :host => 'foobar')

require 'spec_helper'

describe Bunny do

  before(:each) do
    Bunny::Environment.reset
  end
  
  describe ".new" do
    
    it "returns an instance of FakeClient if Bunny::Environment.mode is set to :test" do
      # given
      Bunny::Environment.mode = :test

      # expect
      Bunny.new.should be_an_instance_of(Bunny::FakeClient)
    end
    
    it "uses options hash from Bunny::Environment to when instantiating client" do
      # given
      Bunny::Environment.define do |e|
        e.host = "bunny.com"
        e.vhost = "foo"
        e.user = "me"
        e.pass = "secret"
      end

      # when
      client = Bunny.new

      # expect
      client.host.should == "bunny.com"
      client.vhost.should == "foo"
    end
    
    it "uses options hash passed in to constructor if Bunny::Environment not set" do
      # when
      client = Bunny.new(:host => "wabbit.com", :vhost => "bar")

      # expect
      client.host.should == "wabbit.com"
      client.vhost.should == "bar"
    end
    
    it "merges Bunny::Environment options with options passed in to constructor" do
      # given
      Bunny::Environment.define do |e|
        e.host = "bunny.com"
        e.vhost = "foo"
        e.user = "me"
        e.pass = "secret"
      end

      # when
      client = Bunny.new(:port => "1234", :logging => true)

      # expect
      client.host.should == "bunny.com"
      client.vhost.should == "foo"
      client.port.should == "1234"
    end
    
  end

  describe ".logger" do

    it "returns a Bunny::Logger" do
      # given
      Bunny.logger = Bunny::Logger.new('spec/bunny.log')

      # expect
      Bunny.logger.should be_an_instance_of(Bunny::Logger)
    end

    it "raises a MissingLogger exception if logger is not set" do
      # given
      Bunny.logger = nil

      # expect
      lambda {Bunny.logger}.should raise_error(Bunny::MissingLogger)
    end
    
  end

  describe ".logger=" do

    it "sets a Bunny::Logger" do
      # when
      Bunny.logger = Bunny::Logger.new('spec/bunny.log')

      # expect
      Bunny.logger.should be_an_instance_of(Bunny::Logger)
    end
    
  end

  describe ".client" do

    it "returns a new bunny client" do
      Bunny.client.should be_an_instance_of(Bunny::Client)
    end
    
  end

  describe ".exchange" do

    it "returns a new Bunny exchange object" do
      Bunny.exchange("foo").should be_an_instance_of(Bunny::Exchange)
    end
    
  end

  describe ".delete_queue" do

    it "deletes a specified queue" do
      # given
      Bunny.queue(:a_new_queue)
      `rabbitmqctl list_queues`.should =~ /a_new_queue/

      # when
      Bunny.delete_queue(:a_new_queue)

      # expect
      `rabbitmqctl list_queues`.should_not =~ /a_new_queue/
    end
    
  end

  describe ".queue" do

    it "returns a new Bunny queue object" do
      Bunny.queue("foo").should be_an_instance_of(Bunny::Queue)
    end
    
  end

  describe ".fanout_queue" do

    it "returns a new Bunny queue object that is bound to a fanout exchange" do
      # given
      queue = Bunny.fanout_queue("foos", "my_queue")
      Bunny.publish("foos", "bar", :type => "fanout")

      # expect
      queue.pop[:payload].should == "bar"
    end
    
  end
  
  describe ".publish" do

    it "publishes a messages to a specified queue" do
      # when
      Bunny.publish("foo", "bar")

      # expect
      Bunny.queue("foo").pop[:payload].should == "bar"
    end
    
    it "publishes a messages to an exchange if type is set to 'fanout'" do
      # given
      q1 = Bunny.fanout_queue("foos", "queues1")
      q2 = Bunny.fanout_queue("foos", "queues2")

      # when
      Bunny.publish("foos", "bar", :type => "fanout")

      # expect
      q1.pop[:payload].should == "bar"
      q2.pop[:payload].should == "bar"
    end
    
  end

  before(:each) do
    @b = Bunny.new
    @b.start
  end
  
  it "should connect to an AMQP server" do
    @b.status.should == :connected
  end

  it "should be able to create and open a new channel" do
    c = @b.create_channel
    c.number.should == 2
    c.should be_an_instance_of(Bunny::Channel)
    @b.channels.size.should == 3
    c.open.should == :open_ok
    @b.channel.number.should == 2 
  end
  
  it "should be able to switch between channels" do
    @b.channel.number.should == 1
    @b.switch_channel(0)
    @b.channel.number.should == 0
  end
  
  it "should raise an error if trying to switch to a non-existent channel" do
    lambda { @b.switch_channel(5) }.should raise_error(RuntimeError)
  end

  it "should be able to create an exchange" do
    exch = @b.exchange('test_exchange')
    exch.should be_an_instance_of(Bunny::Exchange)
    exch.name.should == 'test_exchange'
    @b.exchanges.has_key?('test_exchange').should be(true)
  end

  it "should be able to create a queue" do
    q = @b.queue('test1')
    q.should be_an_instance_of(Bunny::Queue)
    q.name.should == 'test1'
    @b.queues.has_key?('test1').should be(true)
  end

  # Current RabbitMQ has not implemented some functionality
  it "should raise an error if setting of QoS fails" do
    lambda { @b.qos(:global => true) }.should raise_error(Bunny::ForcedConnectionCloseError)
    @b.status.should == :not_connected
  end

  it "should be able to set QoS" do
    @b.qos.should == :qos_ok
  end
  
end
