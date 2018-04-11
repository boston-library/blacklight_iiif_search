# return a IIIF Content Search response
module BlacklightIiifSearch
  module Controller
    extend ActiveSupport::Concern

    def iiif_search
      body = {'foo' => 'bar'}.as_json
      render json: body, content_type: 'application/json'
    end
  end
end