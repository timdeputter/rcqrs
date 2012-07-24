module Rcqrs
  
  class ConventionCommand < Rcqrs::BaseCommand
    
    attr_reader :data, :aggregate_id
    
    def self.aggregate_id_attribute name
      define_method(:aggregate_id) do
        instance_variable_get("@" + name.to_s)
      end
    end
    
    def self.aggregate aggregate
      define_method(:aggregate) do
        return aggregate
      end
    end
      
    def initialize(attributes = {})
      super
      attributes.shift
      @data = attributes
    end
        
    def == other
      other.class == self.class && other.aggregate_id == self.aggregate_id && other.data == self.data
    end
  
  
  end

end
