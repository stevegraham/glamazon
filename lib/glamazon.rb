# Glamazon - Couch ORM
# Stevie Graham
# Picklive

require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default
require 'digest/sha2'

%w(accessors attributes finder json associations base).each do |file|
  require File.join(File.dirname(__FILE__), 'glamazon', file)
end

Object.class_eval { def tap() yield self; self; end } unless respond_to? :tap
Object.class_eval { def try(method) send method if respond_to? method; end } unless respond_to? :try
