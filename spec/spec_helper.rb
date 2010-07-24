require 'rubygems'
require 'bundler'

require File.join(File.dirname(__FILE__), '..', 'lib', 'glamazon.rb')

Bundler.require :test

Mule = Class.new { include Glamazon::Base } unless Module.const_defined? 'Mule'