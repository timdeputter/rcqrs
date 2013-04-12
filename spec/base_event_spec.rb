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

  it "should work with no properties defined" do
    class SomeOtherTestEvent < Rcqrs::BaseEvent; end
    lambda {SomeOtherTestEvent.new(name:"Jimbo")}.should raise_error "Property not defined"
  end

  it "should allow to define multiple properties in one line" do
    class TestEvent; property :weight, :size; end
    jim = TestEvent.new(name:"jim", weight: 23, size: 185)
    jim.weight.should be 23
    jim.size.should be 185
  end
end

