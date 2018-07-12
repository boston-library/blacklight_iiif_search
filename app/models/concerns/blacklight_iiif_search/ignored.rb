# returns ignored params
module BlacklightIiifSearch
  module Ignored
    def ignored
      relevant_keys = controller.iiif_search_params.keys
      relevant_keys.delete('solr_document_id')
      relevant_keys - iiif_config[:supported_params]
    end
  end
end
