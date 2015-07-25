class TestCommand
  attr_accessor :param
  
  def initialize param
    @param = param
  end
end

class NonExistingCommand < Rcqrs::BaseCommand
  
end

class TestCommandHandler < Rcqrs::BaseCommandHandler
  
  def self.repository
    @@repository
  end
  
  def self.was_called_with
    @@was_called_with
  end
  
  def execute command
    @@was_called_with = command.param
    @@repository = repository
    @execute_called = true
  end
  
  def execute_called?
    @execute_called
  end
  
end
