describe Rcqrs::BaseEvent do

  class TestEvent < Rcqrs::BaseEvent
    property :name
  end

  subject{TestEvent}

  it "should allow to define properties on an event which can be initalized in the constructor" do
    TestEvent.new(name: "Timbo").name.should == "Timbo"
  end

  it "should allow to use strings as keys" do
    TestEvent.new("name" => "Timbo").name.should == "Timbo"
  end

  it "should reject properties not defined" do
    lambda {TestEvent.new(age: 23)}.should raise_error
    lambda {TestEvent.new("age" =>  23)}.should raise_error
  end

  it "should not allow to define allready used methods as properties" do
    lambda {class TestEvent; property :data ;end}.should raise_error
  end
end

