module Rcqrs
  
  module EventHandler
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def handled_events
        methods.select {|m| m.to_s.match(/^handle_/)}.map{|m| convert_to_event_name(m)}
      end
      
      def convert_to_event_name method
        ((@namespace || "") + method[6..-1].to_s.gsub(/_[a-z]/){|s| s[1].upcase})
      end
      
      def handle aggregate_id, event
       methodname = handler_method_name(event)
       send(methodname, aggregate_id,event)
      end
                  
      def handler_method_name(event)
        "handle" + event.class.name.split("::").last.gsub(/[A-Z]/){|s| "_" + s.downcase}
      end
      
      def handler(event, &handlercode)
        (class << self; self end).class_eval do
          define_method "handle_"+event.to_s.gsub(/[A-Z]/){|s| "_" + s.downcase}, &handlercode
        end
      end
      
    end
    
end

end
