module Rcqrs

  class DomainException < Exception
    
    def initialize reason
      @reason = reason
    end
    
  end

end