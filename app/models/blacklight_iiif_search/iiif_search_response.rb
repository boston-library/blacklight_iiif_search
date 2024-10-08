# frozen_string_literal: true

# corresponds to a IIIF Annotation List
module BlacklightIiifSearch
  class IiifSearchResponse
    include BlacklightIiifSearch::Ignored

    attr_reader :solr_response, :controller, :iiif_config

    ##
    # @param [Blacklight::Solr::Response] solr_response
    # @param [SolrDocument] parent_document
    # @param [CatalogController] controller
    def initialize(solr_response, parent_document, controller)
      @solr_response = solr_response
      @parent_document = parent_document
      @controller = controller
      @iiif_config = controller.iiif_search_config
      @resources = []
      @hits = []
    end

    ##
    # constructs the IIIF::Presentation::AnnotationList
    # @return [IIIF::OrderedHash]
    def annotation_list
      list_id = controller.request.original_url
      anno_list = IIIF::Presentation::AnnotationList.new('@id' => list_id)
      anno_list['@context'] = %w[
        http://iiif.io/api/presentation/2/context.json
        http://iiif.io/api/search/1/context.json
      ]
      anno_list['resources'] = resources
      anno_list['hits'] = @hits
      anno_list['within'] = within
      anno_list['prev'] = paged_url(solr_response.prev_page) if solr_response.prev_page
      anno_list['next'] = paged_url(solr_response.next_page) if solr_response.next_page
      anno_list['startIndex'] = 0 unless solr_response.total_pages > 1
      anno_list.to_ordered_hash(force: true, include_context: false)
    end

    ##
    # Return an array of IiifSearchAnnotation objects
    # @return [Array]
    def resources
      @total = 0
      solr_response['highlighting'].each do |id, hl_hash|
        hit = { '@type': 'search:Hit', 'annotations': [] }
        document = solr_response.documents.find { |v| v[:id] == id }
        if hl_hash.empty?
          @total += 1
          annotation = IiifSearchAnnotation.new(document,
                                                solr_response.params['q'],
                                                0, nil, controller,
                                                @parent_document)
          @resources << annotation.as_hash
          hit[:annotations] << annotation.annotation_id
        else
          hl_hash.each_value do |hl_array|
            hl_array.each_with_index do |hl, hl_index|
              @total += 1
              annotation = IiifSearchAnnotation.new(document,
                                                    solr_response.params['q'],
                                                    hl_index, hl, controller,
                                                    @parent_document)
              @resources << annotation.as_hash
              hit[:annotations] << annotation.annotation_id
            end
          end
        end
        @hits << hit
      end
      @resources
    end

    ##
    # @return [IIIF::Presentation::Layer]
    def within
      within_hash = IIIF::Presentation::Layer.new
      within_hash['ignored'] = ignored
      if solr_response.total_pages > 1
        within_hash['first'] = paged_url(1)
        within_hash['last'] = paged_url(solr_response.total_pages)
      else
        within_hash['total'] = @total
      end
      within_hash
    end

    ##
    # create a URL for the previous/next page of results
    # @return [String]
    def paged_url(page_index)
      controller.solr_document_iiif_search_url(clean_params.merge(page: page_index))
    end

    ##
    # remove ignored or irrelevant params from the params hash
    # @return [ActionController::Parameters]
    def clean_params
      remove = ignored.map(&:to_sym)
      controller.iiif_search_params.except(*%i[page solr_document_id] + remove)
    end
  end
end
