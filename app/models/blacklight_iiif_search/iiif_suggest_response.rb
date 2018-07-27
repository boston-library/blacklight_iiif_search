# corresponds to a IIIF search:TermList
module BlacklightIiifSearch
  class IiifSuggestResponse
    include BlacklightIiifSearch::Ignored

    attr_reader :solr_response, :query, :document_id, :controller, :iiif_config

    ##
    # @param [Blacklight::Solr::Response] solr_response
    # @param [Hash] params
    # @param [CatalogController] controller
    def initialize(solr_response, params, controller)
      @solr_response = solr_response
      @query = params[:q]
      @document_id = params[:solr_document_id]
      @controller = controller
      @iiif_config = controller.iiif_search_config
    end

    ##
    # Constructs the termList as IIIF::Presentation::Resource
    # @return [IIIF::OrderedHash]
    def term_list
      list_id = controller.request.original_url
      term_list = IIIF::Presentation::Resource.new('@id' => list_id)
      term_list['@context'] = 'http://iiif.io/api/search/1/context.json'
      term_list['@type'] = 'search:TermList'
      term_list['terms'] = terms
      term_list['ignored'] = ignored
      term_list.to_ordered_hash(force: true, include_context: false)
    end

    ##
    # Turn solr_response into array of hashes
    # 'try' chain pattern copied from Blacklight::Suggest::Response#suggestions
    # @return [Array]
    def terms
      terms_for_list = []
      terms_array = solr_response.try(:[], 'suggest').try(:[], iiif_config[:suggester_name]).try(:[], query).try(:[], 'suggestions') || []
      terms = terms_array.map { |v| v['term'] }
      terms.sort.each do |term|
        term_hash = { match: term, url: iiif_search_url(term) }
        terms_for_list << term_hash
      end
      terms_for_list
    end

    ##
    # Create a URL corresponding to a IIIF Content Search request for the term
    # @param [String] term
    # @return [String]
    def iiif_search_url(term)
      controller.solr_document_iiif_search_url(document_id, q: term)
    end
  end
end
