require "spec_helper"

describe Rcqrs::Eventbus do
  
  before do
    @id = UUID.generate
    @mockEventStore = mockup
    @bus = Rcqrs::Eventbus.new @mockEventStore
    @eventHandler = mockup
    @bus.register(EventbusTestevent, @eventHandler)
    @anotherHandler = mockup
    @bus.register(EventbusTestevent, @anotherHandler)
    @testevent = EventbusTestevent.new "Hello happened"
  end
  
  it "publishes Events to multiple Eventhandlers" do
    @bus.publish @id, @testevent
    @bus.commit   
    @eventHandler.message(:handle).times(1).with(@id, @testevent).should_be_received
    @anotherHandler.message(:handle).times(1).with(@id, @testevent).should_be_received
  end
  
  it "flushes the events after commiting" do
    @bus.publish @id, @testevent
    @bus.commit
    @bus.commit    
    @eventHandler.message(:handle).times(1).with(@id, @testevent).should_be_received
    @anotherHandler.message(:handle).times(1).with(@id, @testevent).should_be_received
  end
  
  it "ignores double registrations of eventhandlers" do
    @bus.register(EventbusTestevent, @eventHandler)
    @bus.publish @id, @testevent
    @bus.commit   
    @eventHandler.message(:handle).times(1).with(@id, @testevent).should_be_received
  end
  
  it "should only publish events to a eventhandler that is interested in events of that type" do
    yetAnotherHandler = mockup
    @bus.register(EventbusOtherEvent, yetAnotherHandler)
    @bus.publish @id, @testevent
    @bus.commit
    yetAnotherHandler.message(:handle).times(0).should_be_received
  end
  
  it "events are only published after a commit" do
    @bus.publish @id, @testevent    
    @eventHandler.message(:handle).times(0).should_be_received
    @anotherHandler.message(:handle).times(0).should_be_received
  end
  
  it "should save the events in a eventstore during commit" do
    @bus.publish @id, @testevent
    @bus.commit
    @mockEventStore.message(:store).once.with(@id, @testevent).should_be_received
  end
  
  it "should reject events not inherited from base event" do
    expect{ @bus.publish(@id, "no event") }.to raise_error Rcqrs::NotAnEventException
  end
  
  it "should allow to load previous events" do
    eventstore = Object.new
    def eventstore.load_events aggregate_id; "events"; end
    bus = Rcqrs::Eventbus.new eventstore
    bus.load_events(@id).should == "events"
  end
  
end 

describe "Eventbus without eventhandler" do
  
  it "should not throw an error and just save the events" do
    mockEventStore = mockup
    bus = Rcqrs::Eventbus.new mockEventStore
    id = UUID.generate
    testevent = EventbusTestevent.new "Hello happened"
    bus.publish id, testevent
    bus.commit
    mockEventStore.message(:store).once.with(id, testevent).should_be_received    
  end
  
end

class EventbusTestevent < Rcqrs::BaseEvent
  attr_accessor :data
  
  def initialize data
    @data = data
  end
end

class EventbusOtherEvent < Rcqrs::BaseEvent
  def initialize
    
  end
end