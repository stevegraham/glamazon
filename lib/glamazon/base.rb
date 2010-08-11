module Glamazon
  module Base
    def initialize(attributes = {})
      self.id = Digest::SHA1.hexdigest(Time.now.to_f.to_s)
      attributes.each { |k,v| send "#{k}=", v }
    end
    
    def save
      self.class.send(:__instances).merge! id => self
    end
    
    module ClassMethods
      def find(id)
        __instances.detect { |k,v| k == id }.try(:last)
      end
      
      def all
        __instances.map { |k,v| v }
      end
      
      def create(params = {})
        new(params).tap { |r| r.save }
      end
      
      def destroy_all
        __instances.clear
      end
      
      private
      
      def __instances
        @__all_instances__ ||= {}
      end
      
      def self.extended(base)
        base.instance_eval do
          def method_missing(meth, *args, &blk)
            # Dynamic finders, e.g. Klass.find_by_foo('bar)
            a = extract_attribute_from_method_name(meth)
            if match = /find_by_([_a-zA-Z]\w*)/.match(meth.to_s)
              self.class.instance_eval do
                define_method meth do |val|
                   __instances.select { |k,v| v[a] == val.first }.values
                end
              end
              send meth, args
            else
              super
            end
          end

          private

          def extract_attribute_from_method_name(meth)
            meth.to_s.gsub /\w+_by_/, ''
          end
        end
      end
    
    end
    
    def self.included(base)
      base.extend ClassMethods
      base.extend Glamazon::Accessors
    end
  end
end