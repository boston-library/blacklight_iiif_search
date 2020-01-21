# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSearchAnnotation do
  include_context 'iiif_search_shared'

  let(:iiif_search_annotation) do
    described_class.new(page_document, query_term, 0, snippet, controller, parent_document)
  end

  describe 'class' do
    it 'is a IiifSearchAnnotation' do
      expect(iiif_search_annotation.class).to eq(described_class)
    end
  end

  describe '#as_hash' do
    subject(:anno_as_hash) { iiif_search_annotation.as_hash }
    it 'returns the correct object' do
      expect(anno_as_hash.class).to eq(IIIF::Presentation::Annotation)
    end
    it 'has a text resource' do
      expect(anno_as_hash.resource.class).to eq(IIIF::Presentation::Resource)
    end
    it 'has an "on" property' do
      expect(anno_as_hash['on']).not_to be_blank
    end
  end

  describe '#text_resource_for_annotation' do
    subject(:text_resource) { iiif_search_annotation.text_resource_for_annotation }
    it 'returns the correct object' do
      expect(text_resource.class).to eq(IIIF::Presentation::Resource)
      expect(text_resource['chars']).to include(query_term)
      expect(text_resource['chars']).not_to include('<em>')
    end
  end
end
