module BlacklightIiifSearch
  class IiifSearch

    include IiifSearchBehavior

    attr_reader :id, :q, :page, :rows, :iiif_config

    def initialize(params, iiif_search_config)
      @id = params[:solr_document_id]
      @q = params[:q]
      @page = params[:page]
      @iiif_config = iiif_search_config
      @rows = 50
      #@start = start

      # NOT IMPLEMENTED YET
      # @motivation = params[:motivation]
      # @date = params[:date]
      # @user = params[:user]
    end

    ##
    # return a hash of Solr search params
    def solr_params
      {q: q, f: object_relation_solr_params, rows: rows, page: page}
    end

  end
end
