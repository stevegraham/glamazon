require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Glamazon::Associations::HasMany do
  before(:all) { Child = Class.new }
  it "is an array" do
    Glamazon::Associations::HasMany.new(:children).should be_a_kind_of Array
  end
  it 'knows what class it belongs to' do
    klass = self.class
    Glamazon::Associations::HasMany.new(:children, klass).instance_eval { @class }.should == klass
  end
  describe "#<<" do
    it 'raises Glamazon::AssociationTypeMisMatch when the object associated has an incorrect type' do
      association = Glamazon::Associations::HasMany.new(:children)
      lambda { association << 'foo' }.should raise_error Glamazon::AssociationTypeMismatch
    end
  end
end