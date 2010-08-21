require 'active_support/core_ext/hash/indifferent_access'
module Glamazon
  module Attributes
    def method_missing(meth, *args, &blk)
      add_attribute(meth)
      meth.to_s =~ /\=$/ ? send(meth, args.first) : send(meth)
    end
    
    def to_s
      attributes.inspect
    end
    
    def attributes
      @attributes ||= HashWithIndifferentAccess.new
    end
    
    def [](attribute)
      attributes[attribute]
    end
    
    def []=(attribute, value)
      attributes[attribute] = value
    end
    
    def read_attribute(attribute)
      attributes[attribute]
    end
    
    def write_attribute(attribute, value)
      attributes[attribute] = value
    end
    
    private
    def add_attribute(attribute)
      metaclass.class_eval do
        attribute = attribute.to_s.gsub /\=$/, ''
        define_method(attribute) { attributes[attribute] } unless respond_to? attribute
        define_method("#{attribute}=") { |value| attributes[attribute] = value; touch } unless respond_to? "#{attribute}="
      end
    end
    
    def metaclass
      class << self; self; end
    end
    
  end
end