module Rcqrs

class EventTypeRegistry
  
  @events = Hash.new
  
  def self.register name, type
    @events[name] = type
  end
  
  def self.get_type_for name
    @events[name]
  end
end

end