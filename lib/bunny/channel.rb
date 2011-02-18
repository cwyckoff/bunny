module Bunny

  class Channel
    attr_accessor :number, :active, :frame_buffer
    attr_reader :client
    
    def initialize(client)
      @frame_buffer = []
      @client = client
      @number = client.channels.size
      @active = false
      client.channels[@number] = self
    end
    
    def open
      client.channel = self
      client.send_frame(Qrack::Protocol::Channel::Open.new)
      method = client.next_method
      client.check_response(method, Qrack::Protocol::Channel::OpenOk, "Cannot open channel #{number}")

      @active = true
      :open_ok
    end
    
    def close
      client.channel = self
      client.send_frame(Qrack::Protocol::Channel::Close.new(:reply_code => 200, :reply_text => 'bye', :method_id => 0, :class_id => 0))
      method = client.next_method
      client.check_response(method, Qrack::Protocol::Channel::CloseOk, "Error closing channel #{number}")
      
      @active = false
      :close_ok
    end
    
    def open?
      active
    end
    
  end

end