class Bunny::FakeClient

  def start; end
  def stop; end
  def ack(*args); self; end
  def bind(*args); self; end
  def exchange(*args); self; end
  def queue(*args); self; end
  def publish(*args); self; end
  def pop(*args); {:payload => nil}; end
  def subscribe(*args)
    yield if block_given?
  end
  
end
