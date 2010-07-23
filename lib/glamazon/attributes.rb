module Glamazon
  module Attributes
    def method_missing(meth, *args, &blk)
      add_attribute(meth) && send(meth, args.first) if meth.to_s =~ /\=$/
    end
    
    def to_s
      attributes.inspect
    end
    
    def attributes
      @attributes ||= {}
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