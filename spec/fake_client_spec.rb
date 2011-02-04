require 'spec_helper'

module Bunny

  class Foo
    attr_reader :str
    
    def initialize
      @fake_client = FakeClient.new
    end
    
    def test_subscribe(str)
      @str = str
      @fake_client.subscribe do |msg|
        @str += msg
      end
    end
  end
  
  describe FakeClient do

    describe "#subscribe" do

      it "yields a block" do
        # given
        FakeClient.msg = "here's your message"
        foo = Foo.new
        
        # when
        foo.test_subscribe("bar:: ")
        
        # expect
        foo.str.should == "bar:: here's your message"
      end
      
    end
    
  end

end
