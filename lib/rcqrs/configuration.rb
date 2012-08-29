module Rcqrs
  class Configuration
    
    class << self
    
      attr_accessor :eventstore

      def configure
        yield self
      end
      
    end
        
  end
end