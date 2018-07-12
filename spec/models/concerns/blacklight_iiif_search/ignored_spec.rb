require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::Ignored do
  include_context 'iiif_search_shared'

  describe '#ignored' do
    it 'returns an array of ignored parameters' do
      expect(iiif_suggest_response.ignored).to include('date')
    end
  end
end
