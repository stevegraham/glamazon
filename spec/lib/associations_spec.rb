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
    it 'sets up a has many association' do
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
end