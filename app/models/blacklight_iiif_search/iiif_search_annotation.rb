module BlacklightIiifSearch
  class IiifSearchAnnotation

    include IIIF::Presentation

    attr_reader :id, :snippet

    def initialize(id, snippet)
      @id = id
      @snippet = snippet
    end

    def as_hash
      annotation = IIIF::Presentation::Annotation.new('@id' => annotation_id(id))
      annotation.resource = text_resource_for_annotation(snippet)
      annotation['on'] = canvas_uri_for_annotation
      annotation
    end

    def annotation_id(id)
      id
    end

    def canvas_uri_for_annotation
      'TODO'
    end

    def text_resource_for_annotation(snippet)
      IIIF::Presentation::Resource.new('@type' => 'cnt:ContentAsText',
                                       'chars' => snippet.gsub(/<\/?em>/, ''))
    end

  end
end