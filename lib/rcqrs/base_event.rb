class BaseEvent
  
    attr_reader :data

  def initialize data = {}
    @data = data
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
  
  def serialized 
    Marshal::dump(self)
  end
  
  def self.deserialize serialized_event
    Marshal::load(serialized_event)
  end
  
end