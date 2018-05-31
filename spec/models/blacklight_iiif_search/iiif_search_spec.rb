RSpec.describe BlacklightIiifSearch::IiifSearch do
  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:iiif_search) do
    described_class.new({ q: 'foo', solr_document_id: 'bar' },
                        blacklight_config.iiif_search)
  end

  describe 'class' do
    it 'should be a IiifSearch' do
      expect(iiif_search.class).to eq(described_class)
    end
  end

  describe '#solr_params' do
    it 'should respond to #solr_params' do
      expect(iiif_search).to respond_to(:solr_params)
    end

    it 'should return a hash of parameters' do
      solr_params = iiif_search.solr_params
      expect(solr_params[:q]).to eq('foo')
      expect(solr_params[:rows]).to eq(iiif_search.rows)
      expect(solr_params[:f]).not_to be_nil
    end
  end
end
