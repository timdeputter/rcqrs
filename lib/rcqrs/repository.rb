module Rcqrs
  class Repository

    def initialize event_store
      @event_store = event_store
    end
    
    def load(aggregate_class, aggregate_id)
      aggregate = aggregate_class.new aggregate_id
      aggregate.load_from(@event_store.load_events(aggregate_id))
      aggregate
    end
    
    def save aggregate_root
      aggregate_root.pending_events.commit_to @event_store
    end
    
    def fire aggregate_id, event
      unless (event.is_a? BaseEvent) then
        raise NotAnEventException, "Given event has to inherit from BaseEvent"
      end
      @event_store.publish(aggregate_id,event)
    end
  
  end
end