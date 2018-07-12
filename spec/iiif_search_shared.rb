# shared variables that can be used across specs
# https://relishapp.com/rspec/rspec-core/docs/example-groups/shared-context
RSpec.shared_context 'iiif_search_shared' do
  let(:parent_id) { '7s75dn48d' }
  let(:page_id) { '7s75dn58n' }
  let(:query_term) { 'bird' }
  let(:snippet) { 'sed meh put a <em>bird</em> on it chartreuse' }
  let(:controller) { CatalogController.new }
  let(:blacklight_config) { controller.blacklight_config }
  let(:search_params) do
    { q: query_term, solr_document_id: parent_id, date: 'foo' }
  end
  let(:parent_document) { controller.fetch(parent_id)[1] }
  let(:page_document) { controller.fetch(page_id)[1] }
  let(:iiif_search) do
    BlacklightIiifSearch::IiifSearch.new(search_params,
                                         blacklight_config.iiif_search,
                                         parent_document)
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
