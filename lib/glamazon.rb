# Glamazon - Couch ORM
# Stevie Graham
# Picklive

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require
require 'yajl'
require 'digest/sha2'

Dir.glob(File.join File.dirname(__FILE__), 'glamazon', '**', '*.rb').each { |lib| require lib }

module Glamazon
  module Base
    include Glamazon::Attributes
    include Glamazon::JSON
    
    def initialize(attributes = {})
      self.id = Digest::SHA1.hexdigest(Time.now.to_f.to_s)
      attributes.each { |k,v| send "#{k}=", v }
    end
    
    def save
      self.class.send(:__instances).merge! id => self
    end
    
    module ClassMethods
      def find(id)
        __instances.detect { |k,v| k == id }.last
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
    end
  end
end

Object.class_eval { def tap() yield self; self; end } unless respond_to? :tap 