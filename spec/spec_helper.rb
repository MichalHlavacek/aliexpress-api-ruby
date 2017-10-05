require 'coveralls'
Coveralls.wear!

require 'aliexpress'
require 'awesome_print'

gemspec = Gem::Specification.find_by_name('aliexpress')
Dir["#{gemspec.gem_dir}/spec/support/**/*.rb"].each { |f| require f }
