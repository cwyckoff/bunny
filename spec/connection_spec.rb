# connection_spec.rb

describe Bunny do
	
  it "should raise an error if the wrong user name or password is used" do
    b = Bunny.new(:user => 'wrong')
    lambda { b.start}.should raise_error(Bunny::ProtocolError)	
  end

  
end
