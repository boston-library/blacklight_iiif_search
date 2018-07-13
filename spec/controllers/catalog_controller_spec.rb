require 'iiif_search_shared'
RSpec.describe CatalogController do
  include_context 'iiif_search_shared'

  describe 'controller methods' do
    describe '#iiif_search' do
      it 'responds to iiif_search' do
        expect(controller).to respond_to :iiif_search
      end
    end

    describe '#iiif_search_config' do
      subject { controller.iiif_search_config }
      it 'returns the iiif_search config' do
        expect(subject[:full_text_field]).to_not be_falsey
        expect(subject[:object_relation_field]).to_not be_falsey
        expect(subject[:supported_params]).to_not be_empty
      end
    end

    describe '#iiif_search_params' do
      before do
        controller.params = { q: query_term, foo: 'bar' }
      end

      subject { controller.iiif_search_params }
      it 'only returns the permitted params' do
        expect(subject.include?(:q)).to be_truthy
        expect(subject.include?(:foo)).to be_falsey
      end
    end
  end

  describe 'render response' do
    describe 'GET :iiif_search' do
      render_views
      before do
        get :iiif_search,
            params: { q: query_term, solr_document_id: '7s75dn48d' }
      end
      let(:json) { JSON.parse(response.body) }

      it 'returns a response' do
        expect(response).to be_success
      end

      it 'returns a IIIF AnnotationList' do
        expect(json['@type']).to eq('sc:AnnotationList')
        expect(json['resources']).not_to be_blank
        expect(json['within']).not_to be_blank
        expect(json['hits']).not_to be_blank
      end
    end
  end
end
