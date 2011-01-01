require 'spec_helper'
require 'json'

describe Bunny::Filter do

  before(:each) do
    Bunny::Filter.reset
  end
  
  describe ".define" do
    
    it "yields self to allow for setting of config options" do
      # given
      msg = {"foo" => "bar"}
      Bunny::Filter.define do |f|
        f.on_publish {|msg| msg.to_json}
        f.on_consume {|msg| JSON.parse(msg)}
      end

      # expect
      Bunny::Filter.filter_actions[:publish].should be_a_kind_of(Proc)
      Bunny::Filter.filter_actions[:consume].should be_a_kind_of(Proc)
    end
    
  end

  describe ".reset" do
    
    it "sets filter actions to nil" do
      # given
      msg = {"foo" => "bar"}
      Bunny::Filter.define do |f|
        f.on_publish {|msg| msg.to_json}
        f.on_consume {|msg| JSON.parse(msg)}
      end

      # when
      Bunny::Filter.reset

      # expect
      Bunny::Filter.filter_actions.should be_empty
    end
    
  end

  describe ".on_publish" do
    
    it "sets 'publish' filter action" do
      # given
      msg = {"foo" => "bar"}
      Bunny::Filter.on_publish {|msg| msg.to_json}

      # expect
      Bunny::Filter.filter_actions[:publish].should be_a_kind_of(Proc)
    end
    
  end

  describe ".on_consume" do
    
    it "sets 'publish' filter action" do
      # given
      msg = {"foo" => "bar"}
      Bunny::Filter.on_consume {|msg| JSON.parse(msg)}

      # expect
      Bunny::Filter.filter_actions[:consume].should be_a_kind_of(Proc)
    end
    
  end

  describe ".filter" do
    
    it "calls filter proc for filter action" do
      # given
      msg = {"foo" => "bar"}
      Bunny::Filter.define do |f|
        f.on_publish {|msg| msg.to_json}
        f.on_consume {|msg| JSON.parse(msg.to_json)}
      end

      # expect
      Bunny::Filter.filter(:publish, msg).should == msg.to_json
      Bunny::Filter.filter(:consume, msg).should == msg
    end
    
    it "returns message if no filter is set for action" do
      # given
      msg = {"foo" => "bar"}
      Bunny::Filter.reset

      # expect
      Bunny::Filter.filter(:publish, msg).should == msg
      Bunny::Filter.filter(:consume, msg).should == msg
    end
    
  end


end
