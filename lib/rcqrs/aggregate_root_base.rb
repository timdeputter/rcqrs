module Rcqrs

  class AggregateRootBase
    
    def self.handle(eventtype, &handlercode)
      define_method "handle" + eventtype.to_s, &handlercode
    end
    
    def initialize id
      @id = id
    end
    
    def pending_events
      EventCollection.new @id, events
    end
    
    def load_from events
      events.each {|event| handle event}
    end
        
    protected
    
    def fire event
      unless event.is_a? BaseEvent then
        raise NotAnEventException, "Given event has to inherit from BaseEvent"
      end
      events << event
      handle event   
    end  
    
    private
    
    def handle event
      get_handler_method(event).call(event)
    end
    
    def get_handler_method event
      self.private_methods.each do |methodSymbol|
        methodname = methodSymbol.to_s
        if is_eventhandlermethod methodname, event.class
          return self.method(methodname)
        end
      end
      return self.method(:unknown_handler)
    end
   
    
    def unknown_handler event
      
    end
    
    def is_eventhandlermethod(methodname, eventtype)
      methodname.start_with?("handle") && has_event_type_postfix(methodname,eventtype)
    end
    
    def has_event_type_postfix(methodname, eventtype)
      methodname[6,methodname.size] == eventtype.name.split("::").last
    end
    
    def events
      if (@events == nil)
        @events = Array.new
      end
      return @events
    end
    
  end

end