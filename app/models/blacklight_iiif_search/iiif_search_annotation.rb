# corresponds to IIIF Annotation resource
module BlacklightIiifSearch
  class IiifSearchAnnotation
    include IIIF::Presentation
    include IiifSearchAnnotationBehavior

    attr_reader :document, :query, :hl_index, :snippet, :controller, :parent_document

    def initialize(document, query, hl_index, snippet, controller, parent_document)
      @document = document
      @query = query
      @hl_index = hl_index
      @snippet = snippet
      @controller = controller
      @parent_document = parent_document
    end

    def as_hash
      annotation = IIIF::Presentation::Annotation.new('@id' => annotation_id)
      annotation.resource = text_resource_for_annotation if snippet
      annotation['on'] = canvas_uri_for_annotation
      annotation
    end

    def text_resource_for_annotation
      IIIF::Presentation::Resource.new('@type' => 'cnt:ContentAsText',
                                       'chars' => snippet.gsub(/<\/?em>/, ''))
    end
  end
end
