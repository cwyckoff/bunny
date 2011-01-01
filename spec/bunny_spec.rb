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
      client.logging.should == true
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

  describe ".queue" do

    it "returns a new Bunny queue object" do
      Bunny.queue("foo").should be_an_instance_of(Bunny::Queue)
    end
    
  end

end
