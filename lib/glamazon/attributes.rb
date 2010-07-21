module Glamazon
  module Attributes
    def method_missing(meth, *args, &blk)
      add_attribute(meth) && send(meth, args.first) if meth.to_s =~ /\=$/
    end
    
    def to_s
      table.inspect
    end
    
    private
    def add_attribute(attribute)
      metaclass.class_eval do
        attribute = attribute.to_s.gsub /\=$/, ''
        define_method(attribute) { table[attribute] }
        define_method("#{attribute}=") { |value| table[attribute] = value }
      end
    end
    
    def metaclass
      class << self; self; end
    end
    
    def table
      @table ||= {}
    end
  end
end