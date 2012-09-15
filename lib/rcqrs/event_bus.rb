module Rcqrs

  class Eventbus
    
    def initialize eventstore
      @eventstore = eventstore
      @eventhandlers = Hash.new
      @published_events = Array.new
    end
    
    def load_events aggregate_id
      @eventstore.load_events(aggregate_id)
    end
    
    def register eventtype, eventhandler
      @eventhandlers[eventtype] = Array.new unless @eventhandlers.has_key? eventtype
      unless @eventhandlers[eventtype].include? eventhandler
        @eventhandlers[eventtype] << eventhandler      
      end
    end
    
    def publish id, event
      unless event.is_a? BaseEvent then
        raise NotAnEventException, "Given event has to inherit from BaseEvent"
      end
      @published_events << {:id => id, :event => event}
    end
    
    def commit
      store_events
      publish_events
      flush
    end
    
    private
    
    def store_events
        @published_events.each { |event_tuple| @eventstore.store(event_tuple[:id], event_tuple[:event])}
    end
    
    def publish_events
      @published_events.each do |event_tuple|
        if @eventhandlers[event_tuple[:event].class] != nil
          @eventhandlers[event_tuple[:event].class].each {|handler| handler.handle event_tuple[:id], event_tuple[:event] }
        end      
      end
    end
    
    def flush
      @published_events = Array.new
    end
  end

end