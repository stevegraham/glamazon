# Glamazon - Couch ORM
# Stevie Graham
# Picklive

require 'rubygems'
require 'bundler'
Bundler.setup
require 'yajl'

Dir.glob(File.join File.dirname(__FILE__), 'glamazon', '**', '*.rb').each { |lib| require lib }

module Glamazon
  module Base
    include Glamazon::Attributes
    include Glamazon::JSON
    
    def initialize(attributes = {})
      attributes.each { |k,v| send "#{k}=", v }
    end
  end
end