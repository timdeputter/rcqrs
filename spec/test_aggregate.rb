module TestAggregateModule
  
  class TestAggregate < Rcqrs::AggregateRootBase
  
    attr_reader :handledEvents
  
    def initialize id
      super
      @handledEvents = Array.new
    end
  
    def doSomething
      fire TestEventModule::TestEvent.new 
    end
    
    def do_something_else
      fire TestEventModule::AnotherTestEvent.new
    end
    
    def doSomethingStupid
      fire "no Event"
    end
  
    handle :AnotherTestEvent do |event|
      @handledEvents << event
    end
  
    private
    def handleTestEvent event
      @handledEvents << event
    end
  
  end
  
end
