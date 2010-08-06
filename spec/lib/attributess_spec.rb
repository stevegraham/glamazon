require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe "Glamazon::Attributes" do
  let(:mule) { Mule.new }
  let(:hash) { { :foo => 'bar', :baz => 'quux', :steve => 'is a really cool dude' } }
  describe "virtual attributes" do
    describe ".attr_readonly" do
      it "creates an accessor that only writes once and ignores further updates" do
        Mule.class_eval { attr_readonly :socket, :bob, :jim }
        [:socket, :bob, :jim].each do |a|
          mule.should respond_to a
          mule.should respond_to "#{a}="
          mule.send "#{a}=", 'foo'
          mule.send(a).should == 'foo'
          mule.send "#{a}=", 'bar'
          mule.send(a).should == 'foo'
        end
      end
    end
  end
  describe "handling attributes" do
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