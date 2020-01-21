# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::AnnotationBehavior do
  include_context 'iiif_search_shared'

  let(:iiif_search_annotation) do
    BlacklightIiifSearch::IiifSearchAnnotation.new(page_document, query_term,
                                                   0, snippet, controller,
                                                   parent_document)
  end

  describe '#annotation_id' do
    it 'returns a properly formatted URL' do
      expect(iiif_search_annotation.annotation_id).to include("#{parent_id}/canvas/#{page_id}/annotation/0")
    end
  end

  describe '#canvas_uri_for_annotation' do
    it 'returns a properly formatted URL' do
      expect(iiif_search_annotation.canvas_uri_for_annotation).to include("#{parent_id}/canvas/#{page_id}")
    end
  end

  describe '#coordinates' do
    it 'returns a coordinate string' do
      expect(iiif_search_annotation.coordinates).to eq('#xywh=0,0,0,0')
    end
  end
end
