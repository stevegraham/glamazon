require 'active_support/inflector'

module Glamazon
  AssociationTypeMismatch = Class.new StandardError
  module Associations
    def has_many(association)
      define_method association do
        unless ivar = instance_variable_get(:"@__#{association}__")
          instance_variable_set :"@__#{association}__", Glamazon::Associations::HasMany.new(association)
        else
          ivar
        end
      end
    end
    class HasMany < Array
      # inherit from array because we want basic array behaviour. we just want to override Array#<< to raise as Exception if
      # object being added to collection is not an instance of the expected class.
      def initialize(association_type)
        @class = Object.const_get association_type.to_s.singularize.classify
        super 0
      end
      def <<(object)
        if object.instance_of? @class
          super object
        else
          raise Glamazon::AssociationTypeMismatch.new "Object is of incorrect type. Must be an instance of #{@class}."
        end
      end
    end
  end
end