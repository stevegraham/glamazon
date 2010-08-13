require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class Child; include Glamazon::Base; end
class Parent; end
class Associated; end

describe Glamazon::Associations do
  describe '.has_many' do
    before(:each) do
      Associated.class_eval { extend Glamazon::Associations; has_many :children }
      Child.class_eval { extend Glamazon::Associations; belongs_to :associated }
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
    it 'does not append the same instance of an object twice' do
      a = Associated.new
      c = Child.new
      10.times { a.children << c }
      a.children.select { |o| o == c }.size.should == 1
    end
    it 'updates the associated objects belongs_to' do
      a = Associated.new 
      a.children << c = Child.new
      c.associated.should == a
    end
    describe 'callbacks' do
      describe 'after_add' do
        it 'accepts a proc object that is called when an object is added to the collection' do
          Associated.class_eval { has_many :children, :after_add => lambda { |a,c| a.bar; c.foo  } }
          parent = Associated.new
          child  = Child.new
          child.expects(:foo)
          parent.expects(:bar)
          parent.children << child
        end
      end
    end
    describe '#find' do
      it 'finds the record with the given id' do
        a = Associated.new
        10.times { |i| a.children << Child.create(:id => i) }
        Child.find(1).should == a.children.find(1)
      end
    end
    describe 'dynamic finders' do
      it 'finds the records with matching attributes' do
        a = Associated.new
        10.times { |i| a.children << Child.create(:id => i, :foo => i * 10) }
        [Child.find(9).should] == a.children.find_by_foo(90)
      end
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
    it 'accepts a class option if the class name cannot be inferred from the association name' do
      Crazy = Module.new
      Crazy::Parent = Class.new
      Associated.class_eval { belongs_to :parent, :class => 'Crazy::Parent' }
      lambda { Associated.new.parent = Parent.new }.should raise_error Glamazon::AssociationTypeMismatch
      lambda { Associated.new.parent = Crazy::Parent.new }.should_not raise_error Glamazon::AssociationTypeMismatch
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
    it 'accepts a class option if the class name cannot be inferred from the association name' do |variable|
      Crazy = Module.new
      Crazy::Child = Class.new
      Associated.class_eval { belongs_to :child, :class => 'Crazy::Child' }
      lambda { Associated.new.child = Child.new }.should raise_error Glamazon::AssociationTypeMismatch
      lambda { Associated.new.child = Crazy::Child.new }.should_not raise_error Glamazon::AssociationTypeMismatch
    end
  end
end