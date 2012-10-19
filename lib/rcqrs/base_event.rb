module Rcqrs

  class BaseEvent
        
    attr_reader :data, :published_at
    
    def initialize data = {}
      @data = data
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
      @published_at = DateTime.now
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