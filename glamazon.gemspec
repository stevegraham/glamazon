Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'glamazon'
  s.version     = '0.2.1'
  s.summary     = 'In memory models with ActiveRecord compliant interface.'
  s.description = 'In memory models with ActiveRecord compliant interface. Intended for use in eventmachine server applications, desktop application, etc'

  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Stevie Graham'
  s.email             = 'sjtgraham@mac.com'
  s.homepage          = 'http://github.com/stevegraham/glamazon'

  s.add_dependency 'i18n',          '~> 0.5.0'
  s.add_dependency 'yajl-ruby',     '>= 0.7.7'
  s.add_dependency 'activesupport', '>= 3.0.9'

  s.files        = Dir['README.textile', 'lib/**/*']
  s.require_path = 'lib'

  s.has_rdoc = false
end
