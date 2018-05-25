#require 'spec_helper'

RSpec.describe BlacklightIiifSearch::IiifSearch do
  let(:search) do
    described_class.new({q: 'foo', solr_document_id: 'bar'},
                        blacklight_config.iiif_search)
  end

  describe 'class' do
    it 'should be a IiifSearch' do
      expect(search.class).to eq(described_class)
    end
  end

end