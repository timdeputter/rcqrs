module Rcqrs

  class CommandNotValidException < Exception
     
    attr_accessor :errors
     
    def initialize errors
      @errors = errors
    end
  
  end

end