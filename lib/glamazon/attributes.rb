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
      @attributes ||= {}
    end
    
    def [](attribute)
      attributes[attribute.to_s]
    end
    
    def []=(attribute, value)
      attributes[attribute.to_s] = value
    end
    
    def read_attribute(attribute)
      attributes[attribute.to_s]
    end
    
    def write_attribute(attribute, value)
      attributes[attribute.to_s] = value
    end
    
    private
    def add_attribute(attribute)
      metaclass.class_eval do
        attribute = attribute.to_s.gsub /\=$/, ''
        define_method(attribute) { attributes[attribute] }
        define_method("#{attribute}=") { |value| attributes[attribute] = value }
      end
    end
    
    def metaclass
      class << self; self; end
    end
    
  end
end