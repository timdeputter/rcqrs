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
        method[6..-1].to_s.gsub(/_[a-z]/){|s| s[1].upcase}.to_sym
      end
      
      def handle aggregate_id, event
       methodname = handler_method_name(event)
       send(methodname, aggregate_id,event)
      end
      
      def handler_method_name(event)
        "handle" + event.class.to_s.gsub(/[A-Z]/){|s| "_" + s.downcase}
      end
    end
    
end

end