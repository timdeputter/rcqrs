class TestAggregate < Rcqrs::AggregateRootBase

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
