module Rcqrs
  
  class PublishedEvent
    attr_accessor :aggregate_id, :event
    
    def initialize aggregate_id, event
      @aggregate_id, @event = aggregate_id, event   
    end
    
    def ==(other)
      @aggregate_id == other.aggregate_id && @event == other.event
    end
  end
  
end