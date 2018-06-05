require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSearch do
  include_context 'iiif_search_shared'

  describe 'class' do
    it 'is an IiifSearch' do
      expect(iiif_search.class).to eq(described_class)
    end
  end

  describe '#solr_params' do
    it 'responds to #solr_params' do
      expect(iiif_search).to respond_to(:solr_params)
    end

    it 'returns a hash of parameters' do
      solr_params = iiif_search.solr_params
      expect(solr_params[:q]).to eq(query_term)
      expect(solr_params[:rows]).to eq(iiif_search.rows)
      expect(solr_params[:f]).not_to be_nil
    end
  end
end
