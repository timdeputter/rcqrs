require "spec_helper"

describe Rcqrs::Configuration do
  let(:subject) {Rcqrs::Configuration}
  
  it "allows to configure a eventstore" do
    subject.configure do |config|
      subject.eventstore = "eventstore"
    end
    subject.eventstore.should == "eventstore"
  end
  
  it "allows to configure a readmodel-database" do
    subject.configure do |config|
      config.readmodel_database = "readmodeldatabase"
    end
    subject.readmodel_database.should == "readmodeldatabase"
  end
  
end
