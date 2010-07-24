require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Glamazon::Associations::Association do
  it "is an array" do
    Glamazon::Associations::Association.new.should be_a_kind_of Array
  end
end