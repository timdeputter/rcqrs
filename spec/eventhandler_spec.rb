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

  it "handles errors which may occure during event processing" do
    @handler.raise_error = true
    @handler.handle("aggregate_id",@event)
    @handler.exception.message.should == "Error occured"
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
    attr_reader :test_event_handled, :another_test_event_handled, :class_macro_event_handled, :exception
    attr_writer :raise_error
  end
  
  def self.handle_test_event aggregate_id, event
    if @raise_error
      @raise_error = false
      raise "Error occured"
    end
    @test_event_handled = true
  end

  def self.on_exception exception
    @exception = exception
  end
  
  def self.handle_another_test_event aggregate_id, event
    @another_test_event_handled = true
  end
  
  handler :class_macro_event do |aggregate_id, event|
    @class_macro_event_handled = true
  end
  
end
