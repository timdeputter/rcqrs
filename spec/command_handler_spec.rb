require "spec_helper"

describe Rcqrs::CommandSource do
  
  before do
    @commandSource = TestCommandSource.new
  end
  
  it "should find the appropiate command handler and call it" do
    @commandSource.execute TestCommand.new("Parameter")
    TestCommandHandler.was_called_with.should == "Parameter"
  end
  
  it "should raise NameError when commandhandler not found" do
    expect {@commandSource.execute NonExistingCommand.new("Param")}.to raise_error(Rcqrs::CommandHandlerNotFoundError)
  end
  
  it "should raise an Exception if the CommandHandler does not inherit from BaseCommandHandler" do
    expect {@commandSource.execute DoesNotInheritFromBase.new("Param")}.to raise_error(Rcqrs::CommandHandlerDoesNotInheritFromBaseError)
  end
  
  it "should provide the CommandHandler a repository" do
    @commandSource.execute TestCommand.new "param"
    TestCommandHandler.repository.should_not == nil
  end
  
  it "should execute the command handler in a transaction for the eventstore" do
    @commandSource.execute TestCommand.new "param"
    TestEventBus.transaction_executed.should == true    
  end
  
end

class TestEventBus
 
  def self.transaction_executed
    @@transaction_executed
  end
  
  def self.commit
    @@transaction_executed = true
  end
  
  def self.publish(aggregate_id, event)
  end
  
  def self.load_events(aggregate_id)
  end
  
end

class TestCommandSource
  include Rcqrs::CommandSource; 
  def eventbus; TestEventBus; end
end

class DoesNotInheritFromBase
  
end

class DoesNotInheritFromBaseHandler 
  
end