require "spec_helper"


describe Rcqrs::ConventionCommandHandler do
  
  let(:comand_source) {TestCommandSource.new}
  
  it "should execute the method on the aggregate defined by the command name" do
      comand_source.execute(DummyNamespace::TestConventionCommand.new(parameter:"parameter"))
      DummyNamespace::ConventionAggregate.called.should == true
  end
  
end

module DummyNamespace

  class ConventionAggregate < Rcqrs::AggregateRootBase
  
    def test_convention
      @@called = true
    end
    
    def self.called
      @@called
    end
  end
  
  class TestConventionCommand < Rcqrs::ConventionCommand
      aggregate DummyNamespace::ConventionAggregate
      attr_reader :parameter
  end
  
end
