describe Rcqrs::Denormalizer do
  
  describe "mapping of hashes" do
    before do
      @denormalizer = mockup
      @denormalizer.extend Rcqrs::Denormalizer
      @target = mockup    
    end
    
    it "should allow to map hash values named by symbols to corresponding attributes of target" do
      @denormalizer.map({name: "thename", age: 21}).to(@target)
      @target.message(:name=).with("thename").should_be_received
      @target.message(:age=).with(21).should_be_received
    end
    
    it "should allow to map hash values named by strings to corresponding attributes of the target" do
      @denormalizer.map({"name" => "thename", "age" => 21}).to(@target)
      @target.message(:name=).with("thename").should_be_received
      @target.message(:age=).with(21).should_be_received    
    end
    
    it "should allow to reduce the mapped values to specified keys" do
      @denormalizer.map({"name" => "thename", "age" => 21}).only([:name]).to(@target)
      @target.message(:name=).with("thename").should_be_received
      @target.message(:age=).with(21).times(0).should_be_received          
    end
  end
  
  describe "with an object as source" do
    before do
      @denormalizer = mockup
      @denormalizer.extend Rcqrs::Denormalizer
      class Source; attr_accessor :name, :age; end
      @source = Source.new
      @target = mockup
    end
    
    it "should allow to map attributes specified by name to an target object" do
      @source.name = "Bernd"
      @source.age = 534
      @denormalizer.map([:name,:age]).from(@source).to(@target)
      @target.message(:name=).with("Bernd").should_be_received
      @target.message(:age=).with(534).should_be_received
    end
    
    it "should only map those attributes that are specified" do
      @source.name = "Bernd"
      @denormalizer.map([:name]).from(@source).to(@target)
      @target.message(:name=).with("Bernd").should_be_received
      @target.message(:age=).never.should_be_received      
    end
    
  end
  
end