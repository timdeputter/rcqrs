require "spec_helper"

describe Rcqrs::CommandExecutor do
  
  let(:subject){Rcqrs::CommandExecutor}
  
  it "reads the eventstore from the configuration" do
    Rcqrs::Configuration.eventstore = "eventstore"
    subject.eventbus.instance_eval{|bus| bus.instance_variable_get(:@eventstore).should == "eventstore"}
  end
  
end