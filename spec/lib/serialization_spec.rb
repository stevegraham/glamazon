require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Glamazon::JSON do
  let(:mule) { Mule.new }
  it "serializes to JSON" do
    mule.foo = 'bar'
    mule.to_json.should == Yajl::Encoder.new.encode(mule.attributes)
  end
end