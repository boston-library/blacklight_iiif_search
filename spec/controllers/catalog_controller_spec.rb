# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe CatalogController do
  include_context 'iiif_search_shared'

  render_views

  describe 'controller methods' do
    describe '#iiif_search' do
      it 'responds to iiif_search' do
        expect(controller).to respond_to :iiif_search
      end
    end

    describe '#iiif_suggest' do
      it 'responds to iiif_suggest' do
        expect(controller).to respond_to :iiif_suggest
      end
    end

    describe '#iiif_search_config' do
      subject(:iiif_search_config) { controller.iiif_search_config }
      it 'returns the iiif_search config' do
        expect(iiif_search_config[:full_text_field]).not_to be_falsey
        expect(iiif_search_config[:object_relation_field]).not_to be_falsey
        expect(iiif_search_config[:supported_params]).not_to be_empty
      end
    end

    describe '#iiif_search_params' do
      before do
        controller.params = { q: query_term, foo: 'bar' }
      end

      subject(:iiif_search_params) { controller.iiif_search_params }
      it 'only returns the permitted params' do
        expect(iiif_search_params.include?(:q)).to be_truthy
        expect(iiif_search_params.include?(:foo)).to be_falsey
      end
    end

    describe 'before and after actions' do
      before do
        get :iiif_search,
            params: { q: query_term, solr_document_id: parent_id }
      end

      describe '#set_search_builder' do
        it 'uses IiifSearchBuilder' do
          expect(controller.blacklight_config.search_builder_class).to eq(IiifSearchBuilder)
        end
      end

      describe '#set_access_headers' do
        it 'sets the access control header' do
          expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
        end
      end
    end
  end

  describe 'render response' do
    describe 'GET :iiif_search' do
      before do
        get :iiif_search,
            params: { q: query_term, solr_document_id: parent_id }
      end
      let(:json) { response.parsed_body }

      it 'returns a response' do
        expect(response.code).to eq '200'
      end

      it 'returns a IIIF AnnotationList' do
        expect(json['@type']).to eq('sc:AnnotationList')
        expect(json['resources']).not_to be_blank
        expect(json['within']).not_to be_blank
        expect(json['hits']).not_to be_blank
      end
    end

    describe 'GET :iiif_search' do
      before do
        get :iiif_suggest,
            params: { q: suggest_query_term, solr_document_id: parent_id }
      end
      let(:json) { response.parsed_body }

      it 'returns a response' do
        expect(response.code).to eq '200'
      end

      it 'returns a IIIF TermList' do
        expect(json['@type']).to eq('search:TermList')
        expect(json['terms']).not_to be_blank
        expect(json['terms'].first['match']).not_to be_nil
      end
    end
  end
end
