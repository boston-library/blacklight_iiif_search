# customizable behavior for IiifSearchAnnotation
module BlacklightIiifSearch
  module IiifSearchAnnotationBehavior
    def annotation_id
      "#{controller.solr_document_url(parent_id)}/canvas/#{id}/annotation/#{index}"
    end

    def canvas_uri_for_annotation
      "#{controller.solr_document_url(parent_id)}/canvas/#{id}" + coordinates
    end

    # return a string like "#xywh=100,100,250,20"
    # corresponding to coordinates of query term on image
    # local implementation expected
    def coordinates
      ''
    end
  end
end
