require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSearchAnnotationBehavior do
  include_context 'iiif_search_shared'

  let(:iiif_search_annotation) do
    BlacklightIiifSearch::IiifSearchAnnotation.new(page_id, query_term, 0,
                                                   snippet, controller,
                                                   parent_id)
  end

  describe '#annotation_id' do
    subject { iiif_search_annotation.annotation_id }
    it 'should return a properly formatted URL' do
      expect(subject).to include("#{parent_id}/canvas/#{page_id}/annotation/0")
    end
  end

  describe '#canvas_uri_for_annotation' do
    subject { iiif_search_annotation.canvas_uri_for_annotation }
    it 'should return a properly formatted URL' do
      expect(subject).to include("#{parent_id}/canvas/#{page_id}")
    end
  end
end
