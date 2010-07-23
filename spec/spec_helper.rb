require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'glamazon.rb')

Mule = Class.new { include Glamazon::Base } unless Module.const_defined? 'Mule'