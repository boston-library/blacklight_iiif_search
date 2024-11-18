# frozen_string_literal: true

# shared variables that can be used across specs
# https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-context
RSpec.shared_context 'iiif_search_shared' do
  let(:parent_id) { '7s75dn48d' }
  let(:page_id) { '7s75dn58n' }
  let(:query_term) { 'sugar' }
  let(:suggest_query_term) { 'be' }
  let(:snippet) { 'Twelve pounds of <em>sugar</em>, two quarts of water' }
  let(:controller) { CatalogController.new }
  let(:blacklight_config) { controller.blacklight_config }
  let(:search_params) do
    { q: query_term, solr_document_id: parent_id, date: 'foo' }
  end
  let(:suggest_search_params) do
    { q: suggest_query_term, solr_document_id: parent_id, date: 'foo' }
  end
  let(:parent_document) { controller.search_service.fetch(parent_id) }
  let(:page_document) { controller.search_service.fetch(page_id) }
  let(:repository) { Blacklight::Solr::Repository.new(blacklight_config) }

  let(:iiif_search) do
    BlacklightIiifSearch::IiifSearch.new(search_params,
                                         blacklight_config.iiif_search,
                                         parent_document)
  end

  let(:iiif_suggest_search) do
    BlacklightIiifSearch::IiifSuggestSearch.new(suggest_search_params,
                                                repository,
                                                controller)
  end

  let(:iiif_suggest_response) do
    BlacklightIiifSearch::IiifSuggestResponse.new(iiif_suggest_search.suggest_results,
                                                  suggest_search_params,
                                                  controller)
  end

  before do
    controller.params = search_params
    blacklight_config.search_builder_class = IiifSearchBuilder
    controller.request = ActionDispatch::TestRequest.new(env: :test,
                                                         host: 'http://0.0.0.0')
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'iiif_search_shared', include_shared: true
end
