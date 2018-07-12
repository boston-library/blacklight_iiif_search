# IiifSearch
module BlacklightIiifSearch
  class IiifSearch
    include BlacklightIiifSearch::SearchBehavior

    attr_reader :id, :iiif_config, :parent_document, :q, :page, :rows

    def initialize(params, iiif_search_config, parent_document)
      @id = params[:solr_document_id]
      @iiif_config = iiif_search_config
      @parent_document = parent_document
      @q = params[:q]
      @page = params[:page]
      @rows = 50

      # NOT IMPLEMENTED YET
      # @motivation = params[:motivation]
      # @date = params[:date]
      # @user = params[:user]
    end

    ##
    # return a hash of Solr search params
    # if q is not supplied, have to pass some dummy params
    # or else all records matching object_relation_solr_params are returned
    def solr_params
      return { q: 'nil:nil' } unless q
      { q: q, f: object_relation_solr_params, rows: rows, page: page }
    end
  end
end
