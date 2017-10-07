# To publish the next version:
# gem build aliexpress.gemspec
# gem push aliexpress-{VERSION}.gem
Gem::Specification.new do |s|
  s.name        = 'aliexpress'
  s.version     = '0.3'
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Chris Estreich']
  s.email       = ['chris@tophatter.com']
  s.homepage    = 'https://github.com/tophatter/aliexpress-api-ruby'
  s.summary     = 'AliExpress SDK for ruby.'
  s.description = 'AliExpress SDK for ruby.'

  s.extra_rdoc_files = ['README.md']

  s.required_ruby_version = '~> 2.0'

  s.add_dependency 'rest-client', '~> 1.6'
  s.add_dependency 'addressable'
  s.add_dependency 'oauth2'

  s.post_install_message = 'Documentation is available at: http://isvus.aliexpress.com/isv/index.htm'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
