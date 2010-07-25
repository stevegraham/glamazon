Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'glamazon'
  s.version     = '0.1'
  s.summary     = 'In memory models with ActiveRecord compliant interface.'
  s.description = 'In memory models with ActiveRecord compliant interface. Intended for use in eventmachine server applications, desktop application, etc'

  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Stevie Graham'
  s.email             = 'sjtgraham@mac.com'
  s.homepage          = 'http://github.com/stevegraham/glamazon'

  s.files        = Dir['README.textile', 'lib/**/*']
  s.require_path = 'lib'

  s.has_rdoc = false
end