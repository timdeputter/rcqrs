module Rcqrs

  class BaseEvent
        
    attr_reader :data, :published_at

    def initialize data = {}
      data.each do |k,v|
        raise "Property not defined" unless self.class.has_property(k)
        instance_variable_set("@#{k}",v)
      end
      @data = data
    end

    def self.property(*property_names)
      property_names.each do |name|
        raise "data and published_at are not allowed property names" if (["data","published_at"].include? name.to_s)
      end
      property_names.each do |property_name|
        @properties = Array.new unless @properties
        @properties << property_name.to_s
        attr_reader property_name
      end
    end

    def self.has_property(property)
      return false unless @properties
      @properties.include?(property.to_s)
    end
    
    def self.restore_from(data, published_at)
      self.load_from(data, published_at)
    end
    
    def self.load_from data, published_at
      event = self.new(data)
      event.instance_variable_set("@published_at",published_at)
      event
    end
    
    def store_publish_time
      raise "Event has allready a publish date" if(@published_at != nil)
      @published_at = Time.now
    end
    
    def [](index)
      if @data.has_key?(index)
        return @data[index]
      elsif @data.has_key?(index.to_s)
        return @data[index.to_s]
      elsif @data.has_key?(index.to_sym)
        return @data[index.to_sym]
      end
    end
    
    def == other
      @data == other.data
    end
    
  end

end
