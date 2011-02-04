require 'spec_helper'

describe Bunny::ExceptionHandler do

  before(:each) do
    Bunny::ExceptionHandler.reset
  end
  
  describe ".define" do
    
    it "yields self for registering of exceptions" do
      # given
      msg = {:foo => "bar"}
      Bunny::ExceptionHandler.define do |h|
        h.register(:all) do |exception, info|
          Bunny.logger.info("something blew up: #{exception.message}")
        end
      end

      # expect
      Bunny::ExceptionHandler.handlers[:all].first.should be_a_kind_of(Proc)
    end

  end

  describe ".register" do

    before(:each) do
      msg = {:foo => "bar"}
      Bunny::ExceptionHandler.define do |h|
        h.register(:publish) do |exception, info|
          Bunny.logger.info("something blew up: #{exception.message}")
        end
      end
    end
    
    it "sets exceptions in handlers hash" do
      Bunny::ExceptionHandler.handlers[:publish].size.should == 1
    end

    it "adds a #handle method to blocks that are passed in" do
      Bunny::ExceptionHandler.handlers[:publish].first.should respond_to(:handle)
    end

    it "registers custom exception handler classes" do
      # given
      Bunny::ExceptionHandler.reset
      class Bunny::MyExceptionHandler
        def self.handle(exception)
          Bunny.logger.info("something blew up: #{exception.message}")
        end
      end
      Bunny::ExceptionHandler.define { |h| h.register(:publish, Bunny::MyExceptionHandler) }
      
      # expect
      Bunny::ExceptionHandler.handlers[:publish].first.should == Bunny::MyExceptionHandler
    end
    
  end

  describe ".handle" do

    it "delegates to handlers registered for specific events" do
      # given
      Bunny::ExceptionHandler.define do |h|
        h.register(:publish) { |exception, info| Bunny.logger.info("oops!") }
      end

      # expect
      Bunny.logger.should_receive(:info).with("oops!")

      # when
      Bunny::ExceptionHandler.handle(:publish) { raise "oops!" }
    end
    
    it "delegates to handlers registered for 'all' as well as those registered for specific events" do
      # given
      Bunny::ExceptionHandler.define do |h|
        h.register(:publish) { |exception, info| Bunny.logger.info("oops!") }
        h.register(:all) { |exception, info| Bunny.logger.info("oops!") }
      end

      # expect
      Bunny.logger.should_receive(:info).twice.with("oops!")

      # when
      Bunny::ExceptionHandler.handle(:publish) { raise "oops!" }
    end

    it "passes arguments to handlers" do
      # given
      Bunny::ExceptionHandler.define do |h|
        h.register(:publish) { |exception, info| Bunny.logger.info("error #{exception.message} raised in #{info[:action]}") }
      end

      # expect
      Bunny.logger.should_receive(:info).with("error oops! raised in publishing")

      # when
      Bunny::ExceptionHandler.handle(:publish, {:action => "publishing"}) { raise "oops!" }
    end
    
    it "raises exception if no handlers have been registered" do
      lambda {Bunny::ExceptionHandler.handle(:publish) { raise "oops!" }}.should raise_error
    end
    
  end
  
end
