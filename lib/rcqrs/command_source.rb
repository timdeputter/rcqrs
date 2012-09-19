module Rcqrs

  module CommandSource
    
    def execute(command, *params)
      puts "CommandSource.execute(#{command}, #{params})"
      if command.is_a? Symbol
        commandhandler = get_commandhandler_from_symbol(command)
        commandhandler.executeCommand(*params)
      else
        commandhandler = get_commandhandler_from_command(command)
        commandhandler.executeCommand(command)
      end
      eventbus.commit
    end
    
    def get_commandhandler_from_symbol(command_symbol)
      commandhandlerclass = get_handler_class_from_command_name command_symbol.to_s
      commandhandlerclass.new(Repository.new(eventbus))    
    end
    
    def get_commandhandler_from_command command
      commandhandlerclass = get_commandhandler_class(command)
      commandhandlerclass.new(Repository.new(eventbus))
    end
    
    def get_commandhandler_class command
      handler_name = get_handler_class_name(command)
      handlerclass = eval(handler_name)
      checkIfInheritsFromBaseHandler handlerclass
      return handlerclass
    rescue NameError => e
        raise CommandHandlerNotFoundError, "Could not find Commandhandler #{handler_name}, root cause: #{e.to_s}"   
    end
    
    def get_handler_class_name command
      if(command.is_a? ConventionCommand)
        return ConventionCommandHandler.name
      else
        return get_handler_class_from_command_name(command.class.name)
      end
    end
    
    def get_handler_class_from_command_name command_name
      handler_name = String.new
      command_name.to_s.split("_").each do |command_name_part|
        handler_name << capitalize_only_first(command_name_part)
      end
      handler_name << "Handler"
      return handler_name
    end
    
    def capitalize_only_first phrase
      phrase[0].upcase + phrase[1..-1]
    end
  
    def checkIfInheritsFromBaseHandler handlerclass
      unless handlerclass < BaseCommandHandler
        raise CommandHandlerDoesNotInheritFromBaseError, "#{handlerclass.name} does not inherit from BaseCommandHandler"
      end
    end
  
  end
  
  
  
  class Rcqrs::CommandHandlerNotFoundError < Exception
  end
  
  class Rcqrs::CommandHandlerDoesNotInheritFromBaseError < Exception
  end

end