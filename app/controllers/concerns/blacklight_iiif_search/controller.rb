# frozen_string_literal: true

# return a IIIF Content Search response
module BlacklightIiifSearch
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :set_search_builder, only: [:iiif_search]
      after_action :set_access_headers, only: %i[iiif_search iiif_suggest]
    end

    def iiif_search
      @parent_document = search_service.fetch(params[:solr_document_id])
      iiif_search = IiifSearch.new(iiif_search_params, iiif_search_config, @parent_document)
      iiif_search_service = search_service_class.new(config: blacklight_config,
                                                     user_params: iiif_search.solr_params)
      @response = iiif_search_service.search_results
      iiif_search_response = IiifSearchResponse.new(@response, @parent_document, self)

      render json: iiif_search_response.annotation_list, content_type: 'application/json'
    end

    def iiif_suggest
      suggest_search = IiifSuggestSearch.new(params, Blacklight.default_index, self)
      render json: suggest_search.response, content_type: 'application/json'
    end

    def iiif_search_config
      blacklight_config.iiif_search || {}
    end

    def iiif_search_params
      params.permit(:q, :motivation, :date, :user, :solr_document_id, :page)
    end

    private

    def set_search_builder
      blacklight_config.search_builder_class = IiifSearchBuilder
    end

    # allow apps to load JSON received from a remote server
    def set_access_headers
      response.headers['Access-Control-Allow-Origin'] = '*'
    end
  end
end
