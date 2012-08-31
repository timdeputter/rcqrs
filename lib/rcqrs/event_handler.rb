module Rcqrs
  
  module EventHandler
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def handled_events
        methods.select {|m| m.to_s.match(/^handle_/)}.map{|m| convert_to_event_name(m[6..-1])}
      end
      
      def convert_to_event_name method
        full_event_name(method)
      end
      
      def handle aggregate_id, event
       methodname = handler_method_name(event)
       send(methodname, aggregate_id,event)
      end
                  
      def handler_method_name(event)
        "handle" + event.class.name.split("::").last.gsub(/[A-Z]/){|s| "_" + s.downcase}
      end
            
      def namespace namespace
        @namespace = namespace.to_s + "::"
      end
      
      def handler(event, &handlercode)
        puts "defining eventhandler for: #{event}"
        create_handler_method(event,handlercode)
        EventConfigurationBase.handle(full_event_name(event)).with(self)
      end
      
      def full_event_name event_name
        (@namespace || "") + symbol_to_event_name(event_name)
      end
      
      def symbol_to_event_name event
        name = event.to_s.gsub(/_[a-z]/){|s| s[1].upcase}
        name[0] = name[0].upcase
        name
      end

      def create_handler_method(event,handlercode)
        itself = (class << self; self; end)             
        itself.instance_eval do
          define_method "handle_"+event.to_s.gsub(/[A-Z]/){|s| "_" + s.downcase}, &handlercode
        end
      end      
    end
  end 
end
