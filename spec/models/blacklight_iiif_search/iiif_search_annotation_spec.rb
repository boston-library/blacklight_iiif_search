require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSearchAnnotation do
  include_context 'iiif_search_shared'

  let(:iiif_search_annotation) do
    described_class.new(page_id, query_term, 0, snippet, controller, parent_id)
  end

  describe 'class' do
    it 'is a IiifSearchAnnotation' do
      expect(iiif_search_annotation.class).to eq(described_class)
    end
  end

  describe '#as_hash' do
    subject { iiif_search_annotation.as_hash }
    it 'returns the correct object' do
      expect(subject.class).to eq(IIIF::Presentation::Annotation)
    end
    it 'has a text resource' do
      expect(subject.resource.class).to eq(IIIF::Presentation::Resource)
    end
    it 'has an "on" property' do
      expect(subject['on']).not_to be_blank
    end
  end

  describe '#text_resource_for_annotation' do
    subject { iiif_search_annotation.text_resource_for_annotation }
    it 'returns the correct object' do
      expect(subject.class).to eq(IIIF::Presentation::Resource)
      expect(subject['chars']).to include(query_term)
      expect(subject['chars']).not_to include('<em>')
    end
  end
end
