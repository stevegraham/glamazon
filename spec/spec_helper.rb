require 'rubygems'
require 'bundler'

require File.join(File.dirname(__FILE__), '..', 'lib', 'glamazon.rb')

Bundler.require :test

class Mule; include Glamazon::Base end
class Child; end