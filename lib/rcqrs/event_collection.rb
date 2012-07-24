module Rcqrs

  class EventCollection
    
    def initialize aggregateroot_id, events    
      @events = events
      @aggregateroot_id = aggregateroot_id   
    end
    
    def commit_to eventstore
      @events.each do |event|
        eventstore.publish @aggregateroot_id, event
      end
    end
    
  end

end