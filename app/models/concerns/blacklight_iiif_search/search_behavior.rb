# frozen_string_literal: true

# customizable behavior for IiifSearch
module BlacklightIiifSearch
  module SearchBehavior
    ##
    # params to limit the search to items that have some relationship
    # with the parent object (e.g. pages)
    # for ex., return a {key: value} hash where:
    # key:   solr field for image/file to object relationship
    # value: identifier of parent
    # @return [Hash]
    def object_relation_solr_params
      { iiif_config[:object_relation_field] => id }
    end
  end
end
