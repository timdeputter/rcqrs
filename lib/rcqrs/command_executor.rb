module Rcqrs
  
  class CommandExecutor
    extend Rcqrs::CommandSource
    
    def self.eventbus
      if @eventbus == nil 
        @eventbus = Rcqrs::Eventbus.new(Configuration.eventstore)
        EventConfigurationBase.register_all_at(@eventbus)
      end
      @eventbus
    end
    
  end

end
