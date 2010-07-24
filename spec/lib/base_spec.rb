require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Glamazon::Base do
  let(:mule) { Mule.new }
  let(:hash) { { :foo => 'bar', :baz => 'quux', :steve => 'is a really cool dude' } }
  after(:each) { Mule.destroy_all }
  
  describe '.new' do
    it "accepts an optional hash with .new to assign attributes a la ActiveRecord" do
      mule = Mule.new hash
      hash.each { |k,v| mule.send(k).should == v }
    end
    describe 'id attribute' do
      it 'assigns a hash of the epoch as the id' do
        Timecop.freeze Time.now
        mule.id.should == Digest::SHA1.hexdigest(Time.now.to_f.to_s)
        Timecop.return
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
end