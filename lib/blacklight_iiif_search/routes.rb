module BlacklightIiifSearch
  class Routes
    def initialize(defaults = {})
      @defaults = defaults
    end

    def call(mapper, _options = {})
      mapper.get 'iiif_search', action: 'iiif_search'
    end
  end
end