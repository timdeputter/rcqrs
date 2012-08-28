module Rcqrs
  class Configuration
    
    class << self
    
      attr_accessor :eventstore, :readmodel_database

      def configure
        yield self
      end
      
    end
        
  end
end