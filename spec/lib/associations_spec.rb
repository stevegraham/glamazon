require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Glamazon::Associations do
  describe '.has_many' do
    before(:all) { Child = Class.new }
    before(:each) do
      Associated = Class.new
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
end