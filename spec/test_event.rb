module TestEventModule

  class TestEvent < Rcqrs::BaseEvent
  
  end
  
  class AnotherTestEvent < Rcqrs::BaseEvent
    
  end
  
  class ClassMacroEvent < Rcqrs::BaseEvent; end

end
