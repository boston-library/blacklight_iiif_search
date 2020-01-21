# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSuggestResponse do
  include_context 'iiif_search_shared'

  describe 'class' do
    it 'is an IiifSuggestResponse' do
      expect(iiif_suggest_response.class).to eq(described_class)
    end
  end

  describe '#term_list' do
    subject(:response_term_list) { iiif_suggest_response.term_list }

    it 'returns the correct class' do
      expect(response_term_list.class).to eq(IIIF::OrderedHash)
    end

    it 'has the correct content' do
      expect(response_term_list['@id']).not_to be_falsey
      expect(response_term_list['@type']).to eq('search:TermList')
      expect(response_term_list['terms']).not_to be_blank
    end
  end

  describe '#terms' do
    subject(:response_terms) { iiif_suggest_response.terms }

    it 'returns the expected data' do
      expect(response_terms.length).to eq(5)
      expect(response_terms.first[:url]).not_to be_falsey
      expect(response_terms.first[:match].match(/\A#{suggest_query_term}/)).to be_truthy
    end
  end

  describe '#iiif_search_url' do
    subject(:response_urls) { iiif_suggest_response.iiif_search_url(suggest_query_term) }

    it 'returns a search url' do
      expect(response_urls).to include(parent_id)
      expect(response_urls).to include(suggest_query_term)
    end
  end
end
