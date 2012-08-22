describe Rcqrs::EventConfigurationBase do
  
    it "should allow to register a eventhandler" do
      test_event_bus = TestEventBus.new
      Rcqrs::EventConfigurationBase.namespace TestEventModule
      Rcqrs::EventConfigurationBase.register_handler(TestEventHandler)
      Rcqrs::EventConfigurationBase.register_all_at(test_event_bus)
      test_event_bus.register_called.should == true
    end
    
end

class TestEventHandler
  include Rcqrs::EventHandler
  
  def self.handle_test_event account_id, event
  end
  
end

class TestEventBus
  
  attr_reader :register_called
  
  def register eventtype, eventhandler
    @register_called = true
  end
end