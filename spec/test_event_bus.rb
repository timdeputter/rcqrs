class TestEventBus
 
  def self.transaction_executed
    @@transaction_executed
  end
  
  def self.commit
    @@transaction_executed = true
  end
  
  def self.publish(aggregate_id, event)
  end
  
  def self.load_events(aggregate_id)
    Array.new
  end
  
end