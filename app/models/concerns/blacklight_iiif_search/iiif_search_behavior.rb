# customizable behavior for IiifSearch
module BlacklightIiifSearch
  module IiifSearchBehavior
    ##
    # limit the search to items that have some relationship
    # with the parent object (e.g. pages)
    # return a hash with:
    # key:   solr field for image/file to object relationship
    # value: identifier to match
    def object_relation_solr_params
      { iiif_config[:object_relation_field] => id }
    end
  end
end
