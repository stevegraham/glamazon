require 'active_support/inflector'
# For some reason constantize doesn't get included into string when you include only inflector
# I really don't want to include anymore of active_support than necessary
String.class_eval { def constantize() ActiveSupport::Inflector.constantize self end }

module Glamazon
  AssociationTypeMismatch = Class.new StandardError
  module Associations
    def has_many(association, options = {})
      klass = options[:class]
      define_method association do
        unless ivar = instance_variable_get(:"@__#{association}__")
          instance_variable_set :"@__#{association}__", Glamazon::Associations::HasMany.new(association, self, klass, options)
        else
          ivar
        end
      end
    end
    def belongs_to(association, options = {})
      klass = (options[:class] || association).to_s.classify
      define_method(association) { instance_variable_get :"@__#{association}__" }
      define_method("#{association}=") do |object|
        if object.instance_of? klass.classify.constantize
          instance_variable_set :"@__#{association}__", object
        else
          raise Glamazon::AssociationTypeMismatch.new "Object is of incorrect type. Must be an instance of #{@class}."
        end
      end 
    end
    alias :has_one :belongs_to
    class HasMany < Array
      # inherit from array because we want basic array behaviour. we just want to override Array#<< to raise as Exception if
      # object being added to collection is not an instance of the expected class.
      include Glamazon::Finder
      def initialize(association_type, klass = nil, associated_klass = nil, options ={})
        @callbacks = Hash.new { |h,k| h[k] = [] }
        @callbacks[:after_add] << options[:after_add] if options[:after_add]
        @class = klass
        @associated_class = associated_klass ? associated_klass.to_s.classify.constantize : association_type.to_s.singularize.classify.constantize
        puts @associated_class
        super 0
      end
      def all
        self
      end
      def create(attrs={})
        @associated_class.create(attrs).tap { |o| self << o }
      end
      def <<(object)
        if object.instance_of?(@associated_class)
          return if include?(object)
          object.send :"#{@class.class.to_s.downcase}=", @class
          @callbacks[:after_add].each { |cb| cb.call @class, object }
          super object
        else
          raise Glamazon::AssociationTypeMismatch.new "Object is of incorrect type. Must be an instance of #{@class}."
        end
      end
    end
  end
end