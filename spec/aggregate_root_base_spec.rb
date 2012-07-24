#Dir["./lib/infrastructure/*.rb"].each {|file| require file }
#Dir["./spec/infrastructure/testClasses/*.rb"].each {|file| require file }
#require "UUID"
#require "./spec/support/ricko/ricko.rb"
require "spec_helper"

describe Rcqrs::AggregateRootBase do 

  before do
    @idgenerator = UUID.new
    @id = @idgenerator.generate
    @testAggregate = TestAggregate.new @id
    @mockEventStore = mockup
    @events = [TestEvent.new, TestEvent.new]
  end

  it "should handle Events" do
    @testAggregate.doSomething
    @testAggregate.handledEvents.size.should == 1
  end
  
  it "should events when there is no eventhandler method" do
    class UnknownEvent < Rcqrs::BaseEvent; end
    @testAggregate.load_from [TestEvent.new,UnknownEvent.new]
  end
  
  it "should collect Events in a EventCollection" do
    @testAggregate.doSomething
    @testAggregate.pending_events.should be_an_instance_of(Rcqrs::EventCollection)
  end

  it "should have recorded one event to be committed" do
    @testAggregate.doSomething
    @testAggregate.pending_events.commit_to @mockEventStore        
    @mockEventStore.message(:publish).with(any, any(TestEvent)).should_be_received
  end
  
  it "should send its uuid to eventstore to be able to assoziate the events with the aggregate" do
    @testAggregate.doSomething
    @testAggregate.pending_events.commit_to @mockEventStore
    @mockEventStore.message(:publish).with(@id, any()).should_be_received   
  end
  
  it "should be able to load from existing events in the eventstore" do
    @testAggregate.load_from @events
    @testAggregate.handledEvents[0] == @events[0]
    @testAggregate.handledEvents[1] == @events[1]
  end  
  
  it "should only pass the new events to the eventstore, not the ones loaded previously" do
    @testAggregate.load_from @events
    @testAggregate.doSomething
    @testAggregate.pending_events.commit_to @mockEventStore
    @mockEventStore.message(:publish).with(@id,any(TestEvent)).should_be_received
  end
  
  it "events not inherited from BaseEvent are not allowed to be fired" do
    expect {@testAggregate.doSomethingStupid}.to raise_error(Rcqrs::NotAnEventException)
  end
  
end


