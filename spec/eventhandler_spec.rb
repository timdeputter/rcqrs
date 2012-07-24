describe Rcqrs::EventHandler do
  
  before do 
    @handler = mockup
    @handler.include(Rcqrs::EventHandler)
    @event = TestEvent.new
  end
  
  pending "should find the appropriate eventhandler method by the eventname" do
    @handler.handle("aggregate_id",@event)
    @handler.message(:handle_test_event).with("aggregate_id", any(TestEvent)).should_be_received 
  end
  
  pending "should allow to handle multiple events" do
    class AnotherTestEvent < Rcqrs::BaseEvent; end
    @handler.handle("another_id",AnotherTestEvent.new);
    @handler.message(:handle_another_test_event).with("another_id", any(AnotherTestEvent)).should_be_received
  end
  
  it "should allow to get the names of all handled events" do
    class ReadingHandledEventsTestHandler
      include Rcqrs::EventHandler
      def self.handle_test_event; end
    end
    ReadingHandledEventsTestHandler.handled_events.size.should == 1
    ReadingHandledEventsTestHandler.handled_events[0].should == :TestEvent    
  end
    
end