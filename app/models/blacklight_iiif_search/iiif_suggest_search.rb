# IiifSuggestSearch
module BlacklightIiifSearch
  class IiifSuggestSearch
    attr_reader :params, :query, :document_id, :iiif_config, :repository,
                :controller

    ##
    # @param [Hash] params
    # @param [Blacklight::AbstractRepository] repository
    # @param [CatalogController] controller
    def initialize(params, repository, controller)
      @params = params
      @query = params[:q]
      @document_id = params[:solr_document_id]
      @iiif_config = controller.iiif_search_config
      @repository = repository
      @controller = controller
    end

    ##
    # Return the termList response
    # @return [IIIF::OrderedHash]
    def response
      response = IiifSuggestResponse.new(suggest_results, params, controller)
      response.term_list
    end

    ##
    # Query the suggest handler
    # @return [RSolr::HashWithResponse]
    def suggest_results
      suggest_params = { q: query, :'suggest.cfq' => document_id }
      repository.connection.send_and_receive(iiif_config[:autocomplete_handler],
                                             params: suggest_params)
    end
  end
end
