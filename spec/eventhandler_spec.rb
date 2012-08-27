describe Rcqrs::EventHandler do
  
  before do 
    @handler = DummyEventhandler
    @event = TestEventModule::TestEvent.new
  end
  
  it "should find the appropriate eventhandler method by the eventname" do
    @handler.handle("aggregate_id",@event)
    @handler.test_event_handled.should == true 
  end
  
  it "should allow to handle multiple events" do
    class AnotherTestEvent < Rcqrs::BaseEvent; end
    @handler.handle("another_id",AnotherTestEvent.new);
    @handler.another_test_event_handled.should == true
  end
  
  it "should allow to get the names of all handled events" do
    class ReadingHandledEventsTestHandler
      include Rcqrs::EventHandler
      def self.handle_test_event; end
    end
    ReadingHandledEventsTestHandler.handled_events.should == ["TestEvent"]
  end
  
  it "should allow to define a eventhandler via a class macro" do
    @handler.handle("id",TestEventModule::ClassMacroEvent.new)
    @handler.class_macro_event_handled.should == true
  end
  
  it "should automaticly register the eventhandler in the eventconfiguration" do
    bus = DummyEventBus.new
    Rcqrs::EventConfigurationBase.register_all_at bus
    bus.config.should == {TestEventModule::ClassMacroEvent => DummyEventhandler}
  end
      
end

class DummyEventBus
  
  attr_reader :config
  
  def initialize
    @config = Hash.new
  end
  
  def register eventtype,eventhandler
    @config[eventtype] = eventhandler
  end
end 

class DummyEventhandler
  include Rcqrs::EventHandler
  
  namespace TestEventModule
  
  class << self
    attr_reader :test_event_handled, :another_test_event_handled, :class_macro_event_handled    
  end
  
  def self.handle_test_event aggregate_id, event
    @test_event_handled = true
  end
  
  def self.handle_another_test_event aggregate_id, event
    @another_test_event_handled = true
  end
  
  handler :class_macro_event do |aggregate_id, event|
    @class_macro_event_handled = true
  end
  
end