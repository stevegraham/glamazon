module Glamazon
  module Associations
    def has_many(association)
      define_method association do
        ivar = :"@__#{association}__"
        instance_variable_set ivar, Glamazon::Associations::Association.new unless instance_variable_get ivar
      end
    end
    class Association < Array
      # inherit from array because we want basic array behaviour. we just want to override Array#<< to raise as Exception if
      # object being added to collection is not an instance of the expected class.
    end
  end
end