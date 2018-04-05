$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blacklight_iiif_search/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blacklight_iiif_search"
  s.version     = BlacklightIiifSearch::VERSION
  s.authors     = ["Eben English"]
  s.email       = ["eenglish@bpl.org"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of BlacklightIiifSearch."
  s.description = "TODO: Description of BlacklightIiifSearch."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.10"

  s.add_development_dependency "sqlite3"
end
