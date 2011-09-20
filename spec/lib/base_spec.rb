require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Glamazon::Base do
  let(:mule) { Mule.new }
  let(:hash) { { :foo => 'bar', :baz => 'quux', :steve => 'is a really cool dude' } }
  after(:each) { Mule.destroy_all }

  describe 'dynamic finders' do
    describe '.find_all_by_foo' do
      it 'finds objects based on an arbitrary attribute' do
        mule = Mule.create :foo => 'bar'
        Mule.find_all_by_foo('bar').should == [mule]
      end
    end
     describe '.find_by_foo' do
      it 'finds the first object based on an arbitrary attribute' do
        mule = Mule.create :foo => 'bar'
        Mule.find_by_foo('bar').should == mule
      end
    end

    describe '.find_or_create_by_foo' do
      it 'finds objects based on an arbitrary attribute' do
        mule = Mule.create :foo => 'bar'
        Mule.find_or_create_by_foo('bar').should == mule
      end
      it 'creates a new object with the supplied parameters if one cannot be found' do
        Mule.expects(:create).with(:foo => 'bar').returns a = Mule.new(:foo => 'bar')
        Mule.find_or_create_by_foo('bar').should == a
        puts Mule.all
      end
    end
  end
  describe '.new' do
    it "accepts an optional hash with .new to assign attributes a la ActiveRecord" do
      mule = Mule.new hash
      hash.each { |k,v| mule.send(k).should == v }
    end
    describe 'id attribute' do
      it 'assigns a uuid as the id' do
        SecureRandom.expects(:uuid).returns 'f5162adc-7dbc-4fc8-8def-afb1f77da6ae'
        mule.id.should == 'f5162adc-7dbc-4fc8-8def-afb1f77da6ae'
      end
      it 'can optionally be overridden by user' do
        Mule.new(:id => 1).id.should == 1
      end
    end
  end
  describe ".create" do
    it 'creates an instances and persists it in memory' do
      mule = Mule.create :foo => 'bar'
      Mule.all.first.should == mule
    end
  end
  describe '.find' do
    it 'finds the instance of the class with id == argument' do
      mule.save
      Mule.find(mule.id).should == mule
    end
  end
  describe ".all" do
    it "returns an array of all persisted instances of this class" do
      mule.save
      Mule.all.first.should == mule
    end
  end
  describe '.destroy_all' do
    it 'destroys all instances of class' do
      mule.save
      Mule.all.first.should == mule
      Mule.destroy_all
      Mule.all.should be_empty
    end
  end
  describe '#save' do
    it 'persists the instance in memory' do
      mule.foo = nil
      Mule.all.should be_empty
      mule.save
      Mule.all.first.should == mule
    end
  end
  describe '#touch' do
    it 'updates/create the attribute "updated_at" with the current time' do
      Timecop.freeze(Time.now) do
        mule.touch
        mule.updated_at.should == Time.now.getutc
      end
    end
  end
end
