require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe "Glamazon::Attributes" do
  describe "handling attributes" do
    let(:mule) { Mule.new }
    let(:hash) { { :foo => 'bar', :baz => 'quux', :steve => 'is a really cool dude' } }

    it "does not raise NoMethodError when calling a non-existent method" do
      lambda { mule.non_existent_method }.should_not raise_error
    end
    
    it "returns a nil value when a hitherto unknown method is called" do
      mule.non_existent_method.should be_nil
    end
    
    it "creates a getter and setter, and stores the value of the argument when a missing method with method name matching /\=$/" do
      mule.attribute.should be_nil
      mule.attribute = 'foo'
      mule.attribute.should == 'foo'
    end
    
    it "returns an inspectable hash when to_s is called in order to inspect attributes" do
      mule = Mule.new hash
      mule == hash.inspect
    end
  end
end