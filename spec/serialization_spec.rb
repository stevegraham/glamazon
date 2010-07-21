require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Glamazon::Serialization" do
  let(:mule) { Mule.new }
  it "serializes to JSON" do
    mule.to_json.should == "{}"
    mule.foo = 'bar'
    mule.to_json.should == "{\"foo\":\"bar\"}"
  end
end