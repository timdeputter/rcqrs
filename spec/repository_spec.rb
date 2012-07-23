require "spec_helper"

describe Rcqrs::Repository, "when Aggregates are loaded" do
  
  before do
    @aggregate_id = UUID.generate
    @mockEventStore = mock("EventStore")
    @events = [TestEvent.new,TestEvent.new]
    @mockEventStore.should_receive(:load_events).with(@aggregate_id).and_return(@events)
    @repo = Rcqrs::Repository.new @mockEventStore    
  end
  
  it "should return an instance of the given Aggregate-Type to load" do
    loaded_aggregate = @repo.load TestAggregate, @aggregate_id
    loaded_aggregate.should be_an_instance_of TestAggregate
  end
  
  it "the returned aggregate should be initialized with stored events" do
    loaded_aggregate = @repo.load TestAggregate, @aggregate_id
    loaded_aggregate.handledEvents[0].should == @events[0]
    loaded_aggregate.handledEvents[1].should == @events[1]    
  end
  
  it "should only load the events for the aggregateroot with the given id" do
    otherEvents = [TestEvent.new]
    @mockEventStore.stub!(:load_events).and_return(otherEvents)
    loaded_aggregate = @repo.load TestAggregate, @aggregate_id
    loaded_aggregate.handledEvents.size.should == 2
  end
  
end

class TestEvent < BaseEvent
end

class RepoTestEvent < BaseEvent
  
end

class TestAggregate < AggregateRootBase

  attr_reader :handledEvents

  def initialize id
    super
    @handledEvents = Array.new
  end

  def doSomething
    fire TestEvent.new 
  end
  
  def doSomethingStupid
    fire "no Event"
  end

  private
  def handleTestEvent event
    @handledEvents << event
  end

end
