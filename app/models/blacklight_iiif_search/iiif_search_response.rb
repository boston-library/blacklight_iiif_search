module BlacklightIiifSearch
  class IiifSearchResponse
    attr_reader :solr_response, :controller

    def initialize(solr_response, controller, _iiif_search_config)
      @solr_response = solr_response
      @controller = controller
    end
=begin
    def as_json(*_args)
      {
          '@context': %w[
            http://iiif.io/api/presentation/2/context.json
            http://iiif.io/api/search/1/context.json
          ],
          '@id': controller.request.original_url,
          '@type': 'sc:AnnotationList',
          'resources': resources
      }
    end
=end
    def annotation_list
      anno_list = IIIF::Presentation::AnnotationList.new('@id' => anno_list_id)
      anno_list['@context'] = %w[
        http://iiif.io/api/presentation/2/context.json
        http://iiif.io/api/search/1/context.json
      ]
      anno_list['resources'] = resources
      anno_list.to_ordered_hash(force: true, include_context: false)
    end

    def anno_list_id
      controller.request.original_url
    end

    def resources
      resources_array = []
      solr_response['highlighting'].each do |id, hl_hash|
        hl_hash.values.each do |hl_array|
          hl_array.each do |hl|
            resources_array << IiifSearchAnnotation.new(id, hl).as_hash
          end
        end
      end
      resources_array
    end

  end
end