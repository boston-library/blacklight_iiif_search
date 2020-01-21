# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::SearchBehavior do
  include_context 'iiif_search_shared'

  describe '#object_relation_solr_params' do
    subject(:relation_params) { iiif_search.object_relation_solr_params }
    it 'returns a hash with the correct content' do
      expect(relation_params.keys.first).to eq('is_page_of_ssi')
      expect(relation_params.values.first).to eq(parent_id)
    end
  end
end
