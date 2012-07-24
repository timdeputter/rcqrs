require "spec_helper"

describe Rcqrs::BaseCommandHandler do
  
  it "should call execute on inherited class when executeCommand is called" do
    commandHandler = TestCommandHandler.new nil
    commandHandler.executeCommand TestCommand.new("param")
    commandHandler.execute_called?.should == true
  end
  
  it "should validate the given command if it provides validation" do
    commandHandler = TestCommandHandler.new nil
    testCommand = TestCommand.new("param")
    def testCommand.invalid?; true; end
    expect {commandHandler.executeCommand testCommand}.to raise_error Rcqrs::CommandNotValidException
  end
  
  it "the validation does not fail the command is executed" do
    commandHandler = TestCommandHandler.new nil
    testCommand = TestCommand.new("param")
    def testCommand.invalid?; false; end
    commandHandler.executeCommand testCommand
    commandHandler.execute_called?.should == true 
  end
  
  it "should put all validationerrors in the Exception if the validation fails" do
    begin
      commandHandler = TestCommandHandler.new nil
      testCommand = TestCommand.new("param")
      def testCommand.invalid?; true; end
      def testCommand.errormessages; ["Error1", "Error2"]; end
      commandHandler.executeCommand testCommand
    rescue Rcqrs::CommandNotValidException => exception
      exception.errors.should == ["Error1", "Error2"]
    end
  end
  
end
