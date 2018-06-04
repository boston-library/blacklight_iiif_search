# BlacklightIiifSearch
module BlacklightIiifSearch
  require 'blacklight_iiif_search/version'
  require 'blacklight_iiif_search/engine'
  require 'iiif/presentation'
  require 'blacklight'

  autoload :Routes, 'blacklight_iiif_search/routes'

  # returns the full path the the blacklight plugin installation
  def self.root
    @root ||= File.expand_path(File.dirname(File.dirname(__FILE__)))
  end
end
