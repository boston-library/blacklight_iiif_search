# IiifSuggestSearch
module BlacklightIiifSearch
  class IiifSuggestSearch
    attr_reader :params, :query, :document_id, :iiif_config, :repository,
                :controller

    ##
    # @param [Hash] params
    # @param [Blacklight::AbstractRepository] repository
    def initialize(params, repository, controller)
      @params = params
      @query = params[:q]
      @document_id = params[:solr_document_id]
      @iiif_config = controller.iiif_search_config
      @repository = repository
      @controller = controller
    end

    # @return [BlacklightIiifSearch::IiifSuggestResponse]
    def response
      response = IiifSuggestResponse.new(suggest_results, params, controller)
      response.term_list
    end

    ##
    # Query the suggest handler using RSolr::Client::send_and_receive
    # @return [RSolr::HashWithResponse]
    def suggest_results
      suggest_params = { q: query, :'suggest.cfq' => document_id }
      repository.connection.send_and_receive(iiif_config[:autocomplete_path],
                                             params: suggest_params)
    end
  end
end
