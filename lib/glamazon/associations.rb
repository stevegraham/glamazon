module Glamazon
  module Associations
    def has_many(association)
      define_method association do
        unless ivar = instance_variable_get(:"@__#{association}__")
          instance_variable_set :"@__#{association}__", Glamazon::Associations::HasMany.new 
        else
          ivar
        end
      end
    end
    class HasMany < Array
      # inherit from array because we want basic array behaviour. we just want to override Array#<< to raise as Exception if
      # object being added to collection is not an instance of the expected class.
    end
  end
end