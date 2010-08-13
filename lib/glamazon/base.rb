module Glamazon
  module Base
    include Glamazon::Attributes
    include Glamazon::JSON
    
    def initialize(attributes = {})
      self.id = Digest::SHA1.hexdigest(Time.now.to_f.to_s)
      attributes.each { |k,v| send "#{k}=", v }
    end
    
    def save
      self.class.all << self
    end
    
    module ClassMethods
      def all
        @__all_instances__ ||= []
      end
      
      def create(params = {})
        new(params).tap { |r| r.save }
      end
      
      def destroy_all
        all.clear
      end
    
    end
    
    def self.included(base)
      base.extend ClassMethods
      base.extend Glamazon::Accessors
      base.extend Glamazon::Finder
    end
  end
end