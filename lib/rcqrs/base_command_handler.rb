module Rcqrs

  class BaseCommandHandler
    
    def initialize repository
      @repository = repository
    end
    
    def executeCommand command
      if command.respond_to?(:invalid?) && command.invalid?
        if command.respond_to? :errormessages
          raise CommandNotValidException.new(command.errormessages)
        else
          raise CommandNotValidException.new []
        end
      end
      execute command
    end
    
    protected
    def repository
      @repository
    end
  
  end

end