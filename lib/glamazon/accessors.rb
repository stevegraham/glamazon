module Glamazon
  module Accessors
    def attr_readonly(*attrs)
      attrs.each do |attribute|
        define_method "#{attribute}=" do |obj|
          instance_variable_set :"@#{attribute}", obj unless instance_variable_get :"@#{attribute}"
        end
        attr_reader attribute
      end
    end
  end
end