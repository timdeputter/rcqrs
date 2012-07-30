require "spec_helper"

describe Rcqrs::Repository, "when Aggregates are loaded" do
  
  before do
    @aggregate_id = UUID.generate
    @mockEventStore = mock("EventStore")
    @events = [TestEventModule::TestEvent.new,TestEventModule::TestEvent.new]
    @mockEventStore.should_receive(:load_events).with(@aggregate_id).and_return(@events)
    @repo = Rcqrs::Repository.new @mockEventStore    
  end
  
  it "should return an instance of the given Aggregate-Type to load" do
    loaded_aggregate = @repo.load TestAggregateModule::TestAggregate, @aggregate_id
    loaded_aggregate.should be_an_instance_of TestAggregateModule::TestAggregate
  end
  
  it "the returned aggregate should be initialized with stored events" do
    loaded_aggregate = @repo.load TestAggregateModule::TestAggregate, @aggregate_id
    loaded_aggregate.handledEvents[0].should == @events[0]
    loaded_aggregate.handledEvents[1].should == @events[1]    
  end
  
  it "should only load the events for the aggregateroot with the given id" do
    otherEvents = [TestEventModule::TestEvent.new]
    @mockEventStore.stub!(:load_events).and_return(otherEvents)
    loaded_aggregate = @repo.load TestAggregateModule::TestAggregate, @aggregate_id
    loaded_aggregate.handledEvents.size.should == 2
  end
  
end


describe Rcqrs::Repository, "when Aggregateroots are saved" do
  
  before do
    @aggregate_id = UUID.generate
    @testaggregate = TestAggregateModule::TestAggregate.new @aggregate_id
    @mockEventStore = mock("Eventbus")
    @repo = Rcqrs::Repository.new @mockEventStore    
  end
  
  it "should save all the pending events of the aggregateroot" do
    @mockEventStore.should_receive(:publish).with(@aggregate_id, an_instance_of(TestEventModule::TestEvent))
    @testaggregate.doSomething
    @repo.save @testaggregate
  end
  
end

describe Rcqrs::Repository do
  
    before do
      @aggregate_id = UUID.generate
      @testaggregate = TestAggregateModule::TestAggregate.new @aggregate_id
      @mockEventStore = mock("Eventbus")
      @repo = Rcqrs::Repository.new @mockEventStore    
    end
  
    it "should allow to fire domainevents directly" do
      repoTestEvent = RepoTestEvent.new
      @mockEventStore.should_receive(:publish).with(@aggregate_id,repoTestEvent)
      @repo.fire(@aggregate_id, repoTestEvent)
    end
    
    it "should reject events not inherited from base event" do
      expect{ @repo.fire(@aggregate_id,"no Event") }.to raise_error(Rcqrs::NotAnEventException)
    end
    
end

class RepoTestEvent < Rcqrs::BaseEvent
  
end

