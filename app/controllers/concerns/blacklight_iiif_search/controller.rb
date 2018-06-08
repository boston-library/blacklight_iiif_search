# return a IIIF Content Search response
module BlacklightIiifSearch
  module Controller
    extend ActiveSupport::Concern

    def iiif_search
      blacklight_config.search_builder_class = IiifSearchBuilder
      iiif_search = IiifSearch.new(iiif_search_params, iiif_search_config)
      (@response, @document_list) = search_results(iiif_search.solr_params)
      iiif_search_response = IiifSearchResponse.new(@response,
                                                    params[:solr_document_id],
                                                    self,
                                                    iiif_search_config)
      body = iiif_search_response.annotation_list
      response.headers['Access-Control-Allow-Origin'] = '*'
      render json: body, content_type: 'application/json'
    end

    def iiif_search_config
      blacklight_config.iiif_search || {}
    end

    def iiif_search_params
      params.permit(:q, :motivation, :date, :user, :solr_document_id, :page)
    end

  end
end
