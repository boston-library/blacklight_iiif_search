namespace :blacklight_iiif_search do
  namespace :index do
    desc 'Put sample data into solr'
    task seed: [:environment] do
      require 'yaml'
      docs = YAML.safe_load(File.open(File.join(BlacklightIiifSearch.root,
                                                'spec',
                                                'fixtures',
                                                'sample_solr_documents.yml')))
      conn = Blacklight.default_index.connection
      conn.add docs
      conn.commit
    end
  end
end