lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require 'blacklight_iiif_search/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'blacklight_iiif_search'
  s.version     = BlacklightIiifSearch::VERSION
  s.authors     = ['Eben English']
  s.email       = ['eenglish@bpl.org']
  s.homepage    = 'https://github.com/boston-library/blacklight_iiif_search'
  s.summary     = 'Blacklight IIIF Search plugin'
  s.description = 'Blacklight IIIF Search plugin'
  s.license     = 'Apache-2.0'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']
  s.source

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = s.homepage

  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'rails', '>= 6.1', '< 8'
  s.add_dependency 'blacklight', '~> 8.0'
  s.add_dependency 'iiif-presentation'
  s.add_dependency 'ffi', '~> 1.16.3' # https://github.com/ffi/ffi/issues/1103

  s.add_development_dependency 'rspec-rails', '>= 6.1', '< 8'
  s.add_development_dependency 'solr_wrapper', '~> 4.0'
  s.add_development_dependency 'engine_cart', '~> 2.1'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'bixby', '~> 4.0.0' # TODO: update to 5.0
end
