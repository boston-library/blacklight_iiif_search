# return a IIIF Content Search response
module BlacklightIiifSearch
  module Controller
    extend ActiveSupport::Concern

    def iiif_search
      blacklight_config.search_builder_class = IiifSearchBuilder
      _parent_response, @parent_document = fetch(params[:solr_document_id])
      iiif_search = IiifSearch.new(iiif_search_params, iiif_search_config,
                                   @parent_document)
      @response, _document_list = search_results(iiif_search.solr_params)
      iiif_search_response = IiifSearchResponse.new(@response,
                                                    @parent_document,
                                                    self, iiif_search_config)
      response.headers['Access-Control-Allow-Origin'] = '*'
      render json: iiif_search_response.annotation_list,
             content_type: 'application/json'
    end

    def iiif_suggest
      suggest_search = IiifSuggestSearch.new(params, repository, self)
      #suggest_resp = IiifSuggestResponse.new(suggest_search.suggest_results,
      #                                       self)
      response.headers['Access-Control-Allow-Origin'] = '*'
      render json: suggest_search.response,
             content_type: 'application/json'
    end

    def iiif_search_config
      blacklight_config.iiif_search || {}
    end

    def iiif_search_params
      params.permit(:q, :motivation, :date, :user, :solr_document_id, :page)
    end
  end
end
