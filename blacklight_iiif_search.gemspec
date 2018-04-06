$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'blacklight_iiif_search/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'blacklight_iiif_search'
  s.version     = BlacklightIiifSearch::VERSION
  s.authors     = ['Eben English']
  s.email       = ['eenglish@bpl.org']
  s.homepage    = 'http://projectblacklight.org/'
  s.summary     = 'Blacklight IIIF Search plugin'
  s.description = 'Blacklight IIIF Search plugin'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 4.2', '< 6'
  s.add_dependency 'blacklight', '~> 6.0'
  s.add_dependency 'iiif-presentation'

  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'solr_wrapper'
  s.add_development_dependency 'engine_cart'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rubocop', '~> 0.50.0'
  s.add_development_dependency 'rubocop-rspec', '~> 1.18.0'
end
