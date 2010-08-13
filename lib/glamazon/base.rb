module Glamazon
  module Base
    include Glamazon::Attributes
    include Glamazon::JSON
    
    def initialize(attributes = {})
      self.id = Digest::SHA1.hexdigest(Time.now.to_f.to_s)
      attributes.each { |k,v| send "#{k}=", v }
    end
    
    def save
      self.class.send(:__instances) << self
    end
    
    module ClassMethods
      def all
        __instances
      end
      
      def create(params = {})
        new(params).tap { |r| r.save }
      end
      
      def destroy_all
        __instances.clear
      end
      
      private
      
      def __instances
        @__all_instances__ ||= []
      end
    
    end
    
    def self.included(base)
      base.extend ClassMethods
      base.extend Glamazon::Accessors
      base.extend Glamazon::Finder
    end
  end
end