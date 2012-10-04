module Rcqrs

  module Denormalizer
    
    
    attr_accessor :model      
    
    def map to_map
      if to_map.is_a? Hash
        return HashMapper.new to_map
      end
      return AttributeMapper.new to_map
    end
        
    def method_missing(name, *args,&block)
      if(Configuration.readmodel_database.respond_to?(name))
        if(@model)  
          Configuration.readmodel_database.send(name,model,*args,&block)
        else
          Configuration.readmodel_database.send(name,*args,&block)
        end  
      else
        super
      end    
    end
    
    class AttributeMapper
      
      def initialize attribute_specification
        @attribute_specification = attribute_specification      
      end
      
      def from source
        @source = source
        self
      end
      
      def to target
        @attribute_specification.each do |attribute_name|
            if(target.is_a? Hash)
              target[attribute_name] = @source.send(attribute_name)
            else
              target.send(attribute_name.to_s + "=",@source.send(attribute_name))
            end  
        end
      end
           
    end
    
    class HashMapper
      
        def initialize hash_to_map
          @hash_to_map = hash_to_map
        end
        
        def only keys
          @hash_to_map = @hash_to_map.select {|key,value| keys.count{|k| k.to_s == key.to_s} > 0}
          self
        end
        
        def to target
          @hash_to_map.each do |key,value|
            if(target.is_a? Hash)
              if(target.has_key? key.to_sym)
                target[key.to_sym] = value
              else
                target[key] = value
              end  
            else
              target.send(key.to_s + "=", value)            
            end  
          end
        end
        
    end
    
  end

end