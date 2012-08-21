module Rcqrs

  class EventConfigurationBase
    
      @configs = Array.new
    
    def self.register_handler(handler)
      handler.handled_events.each do |event_name|      
        handle(eval(event_name)).with(handler)
      end
    end
    
    def self.register_all_at(eventbus)
      if(@configs != nil)
        @configs.each do |config| 
          eventbus.register config.eventtype, config.eventhandler
        end
      end
    end
    
    def self.handle(eventtype)
      @configs = Array.new if (@configs == nil)
      config = EventConfig.new(eventtype)
      @configs << config
      config
    end
    
  end
  
  class EventConfig
    
    attr_reader :eventtype, :eventhandler
    
    def initialize eventtype
      @eventtype = eventtype
    end
    
    def with eventhandler
      @eventhandler = eventhandler
    end
  end

end