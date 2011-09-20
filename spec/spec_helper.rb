require 'rubygems'
require 'bundler'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'glamazon.rb'))

Bundler.require :test

class Mule; include Glamazon::Base; end

RSpec.configure { |c| c.mock_with :mocha }
