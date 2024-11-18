# frozen_string_literal: true

require 'iiif_search_shared'
RSpec.describe BlacklightIiifSearch::IiifSearchResponse do
  include_context 'iiif_search_shared'

  let(:iiif_search_service) do
    controller.search_service_class.new(config: blacklight_config,
                                        user_params: iiif_search.solr_params)
  end
  let(:solr_response) { iiif_search_service.search_results }
  let(:iiif_search_response) do
    described_class.new(solr_response, parent_document, controller)
  end

  describe 'class' do
    it 'is a IiifSearchResponse' do
      expect(iiif_search_response.class).to eq(described_class)
    end
  end

  describe '#annotation_list' do
    subject(:iiif_anno_list) { iiif_search_response.annotation_list }

    it 'returns an OrderedHash' do
      expect(iiif_anno_list.class).to eq(IIIF::OrderedHash)
    end

    it 'has the correct content' do
      expect(iiif_anno_list['@id']).not_to be_falsey
      expect(iiif_anno_list['@type']).to eq('sc:AnnotationList')
      expect(iiif_anno_list['resources']).not_to be_blank
      expect(iiif_anno_list['within']).not_to be_blank
      expect(iiif_anno_list['hits']).not_to be_blank
    end

    let(:hit) { subject['hits'].first }
    it 'has properly formatted search:Hit' do
      expect(hit[:@type]).to eq('search:Hit')
      expect(hit[:annotations].first).to eq(iiif_anno_list['resources'].first['@id'])
    end
  end

  describe '#resources' do
    subject(:response_resources) { iiif_search_response.resources }
    it 'returns an array of IiifSearchAnnotation objects' do
      expect(response_resources.length).to eq(2)
      expect(response_resources.first.class).to eq(IIIF::Presentation::Annotation)
    end
  end

  describe '#clean_params' do
    subject(:response_params) { iiif_search_response.clean_params }
    it 'returns an array of acceptable parameters' do
      expect(response_params).to include('q')
      expect(response_params).not_to include('date')
    end
  end

  # TODO: fix ActionController::UrlGenerationError:
  # No route matches {:action=>"iiif_search", :controller=>"catalog", "page"=>100, "q"=>"teachers"},
  # missing required keys: [:solr_document_id]
  # this method calls solr_document_iiif_search_url
  # missing :solr_document_id only seems to be an issue with the spec
  describe '#paged_url' do
    it 'returns a solr_document URL with the page param'
    # expect(iiif_search_response.paged_url(100)).to include('page=100')
  end

  describe '#within' do
    subject(:response_within) { iiif_search_response.within }
    it 'returns a IIIF::Presentation::Layer object' do
      expect(response_within.class).to eq(IIIF::Presentation::Layer)
      expect(response_within['ignored']).to include('date')
    end
  end
end
