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
    end
    
    def self.included(base)
      base.extend ClassMethods
      base.extend Glamazon::Accessors
    end
  end
end