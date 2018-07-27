# returns ignored params
module BlacklightIiifSearch
  module Ignored
    ##
    # Return an array of ignored params
    # @return [Array]
    def ignored
      relevant_keys = controller.iiif_search_params.keys
      relevant_keys.delete('solr_document_id')
      relevant_keys - iiif_config[:supported_params]
    end
  end
end
