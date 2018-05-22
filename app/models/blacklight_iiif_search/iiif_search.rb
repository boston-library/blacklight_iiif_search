module BlacklightIiifSearch
  class IiifSearch
    attr_reader :id, :q, :page

    def initialize(params, iiif_search_config)
      @id = params[:solr_document_id]
      @q = params[:q]
      @page = params[:page]
      @iiif_config = iiif_search_config
      #@start = start
      #@rows = 100

      # NOT IMPLEMENTED YET
      # @motivation = params[:motivation]
      # @date = params[:date]
      # @user = params[:user]
    end

    ##
    # return a hash of Solr search params
    def solr_params
      {q: q, f: object_relation_solr_params, rows: 2, page: page}
    end

    ##
    # return a hash with:
    # key:   solr field for image/file to object relationship
    # value: identifier to match
    def object_relation_solr_params
      {@iiif_config[:object_relation_field] => "info:fedora/#{id}"} # TODO: BPL SPECIFIC
    end

  end
end
