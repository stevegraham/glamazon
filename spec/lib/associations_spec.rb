require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

Child = Class.new
Parent = Class.new

describe Glamazon::Associations do
  before(:each) { Associated = Class.new }
  describe '.has_many' do
    before(:each) do
      Associated.class_eval { extend Glamazon::Associations; has_many :children } 
    end 
    it 'sets up a has many association' do
      Associated.new.should respond_to :children
    end
    it 'accepts a class option if the class name cannot be inferred from the association name' do |variable|
      Child::UnLoved = Class.new
      Associated.class_eval { has_many :children, :class => 'Child::UnLoved' }
      lambda { Associated.new.children << Child.new }.should raise_error Glamazon::AssociationTypeMismatch
      lambda { Associated.new.children << Child::UnLoved.new }.should_not raise_error Glamazon::AssociationTypeMismatch
    end
    describe 'the instance method' do
      it 'returns an instance of Glamazon::Associations::Association' do
        Associated.new.children.should be_an_instance_of Glamazon::Associations::HasMany
      end
    end
  end
  describe '.belongs_to' do
    before(:each) do
      Associated.class_eval { extend Glamazon::Associations; belongs_to :parent }
    end
    it 'sets up a belongs to association' do
      Associated.new.should respond_to :parent
    end
    describe 'the instance method' do
      it 'returns an instance of Glamazon::Associations::Association' do
        Associated.new.parent.should be_nil
      end
      it 'returns the associated object when one has been associated' do
        associated = Associated.new
        associated.parent = parent = Parent.new
        associated.parent.should == parent
      end
      it 'raises Glamazon::AssociationTypeMisMatch when the object associated has an incorrect type' do
        lambda { Associated.new.parent = 'foo' }.should raise_error Glamazon::AssociationTypeMismatch
      end
    end
  end
  describe '.has_one' do
    before(:each) do
      Associated.class_eval { extend Glamazon::Associations; has_one :child }
    end
    it 'sets up a has one association' do
      Associated.new.should respond_to :child
    end
    describe 'the instance method' do
      it 'returns an instance of Glamazon::Associations::Association' do
        Associated.new.child.should be_nil
      end
      it 'returns the associated object when one has been associated' do
        associated = Associated.new
        associated.child = child = Child.new
        associated.child.should == child
      end
      it 'raises Glamazon::AssociationTypeMisMatch when the object associated has an incorrect type' do
        lambda { Associated.new.child = 'foo' }.should raise_error Glamazon::AssociationTypeMismatch
      end
    end
  end
end