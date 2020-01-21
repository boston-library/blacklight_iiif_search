# frozen_string_literal: true

module BlacklightIiifSearch
  class Routes
    def initialize(defaults = {})
      @defaults = defaults
    end

    def call(mapper, _options = {})
      mapper.get 'iiif_search', action: 'iiif_search'
      mapper.get 'iiif_suggest', action: 'iiif_suggest'
    end
  end
end
