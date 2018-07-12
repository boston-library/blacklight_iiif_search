require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSuggestResponse do
  include_context 'iiif_search_shared'

  describe 'class' do
    it 'is an IiifSuggestResponse' do
      expect(iiif_suggest_response.class).to eq(described_class)
    end
  end

  describe '#term_list' do
    subject { iiif_suggest_response.term_list }

    it 'returns the correct class' do
      expect(subject.class).to eq(IIIF::OrderedHash)
    end

    it 'has the correct content' do
      expect(subject['@id']).not_to be_falsey
      expect(subject['@type']).to eq('search:TermList')
      expect(subject['terms']).not_to be_blank
    end
  end

  describe '#terms' do
    subject { iiif_suggest_response.terms }

    it 'returns the expected data' do
      expect(subject.length).to eq(2)
      expect(subject.first[:url]).not_to be_falsey
      expect(subject.first[:match]).to include(query_term)
    end
  end

  describe '#iiif_search_url' do
    subject { iiif_suggest_response.iiif_search_url(query_term) }

    it 'returns a search url' do
      expect(subject).to include(parent_id)
      expect(subject).to include(query_term)
    end
  end
end
