# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSuggestSearch do
  include_context 'iiif_search_shared'

  describe 'class' do
    it 'is an IiifSuggestSearch' do
      expect(iiif_suggest_search.class).to eq(described_class)
    end
  end

  describe '#response' do
    subject(:suggest_response) { iiif_suggest_search.response }

    it 'returns the correct class' do
      expect(suggest_response.class).to eq(IIIF::OrderedHash)
    end

    it 'returns the expected data' do
      expect(suggest_response['terms'].length).to eq(5)
    end
  end

  describe '#suggest_results' do
    subject(:suggest_results) { iiif_suggest_search.suggest_results }

    it 'returns the correct class' do
      expect(suggest_results.class).to eq(RSolr::HashWithResponse)
    end

    it 'returns the expected data' do
      terms = suggest_results['suggest'][blacklight_config.iiif_search[:suggester_name]][suggest_query_term]['suggestions']
      expect(terms.length).to eq(5)
      expect(terms.first['term'].match(/#{suggest_query_term}/)).to be_truthy
    end
  end
end
