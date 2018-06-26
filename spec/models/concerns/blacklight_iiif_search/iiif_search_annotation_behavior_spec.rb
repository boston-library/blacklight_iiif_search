require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSearchAnnotationBehavior do
  include_context 'iiif_search_shared'

  let(:iiif_search_annotation) do
    BlacklightIiifSearch::IiifSearchAnnotation.new(page_document, query_term,
                                                   0, snippet, controller,
                                                   parent_document)
  end

  describe '#annotation_id' do
    subject { iiif_search_annotation.annotation_id }
    it 'returns a properly formatted URL' do
      expect(subject).to include("#{parent_id}/canvas/#{page_id}/annotation/0")
    end
  end

  describe '#canvas_uri_for_annotation' do
    subject { iiif_search_annotation.canvas_uri_for_annotation }
    it 'returns a properly formatted URL' do
      expect(subject).to include("#{parent_id}/canvas/#{page_id}")
    end
  end

  describe '#coordinates' do
    subject { iiif_search_annotation.coordinates }
    it 'returns a coordinate string' do
      expect(subject).to eq('#xywh=0,0,0,0')
    end
  end
end
