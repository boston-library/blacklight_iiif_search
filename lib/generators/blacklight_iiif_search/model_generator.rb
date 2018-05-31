# add the SearchBuilder to the implementing application
require 'rails/generators'

module BlacklightIiifSearch
  class ModelGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :search_builder_model, :type => :string, :default => 'search_builder'

    desc 'This generator makes the following changes to your app:
        1. Adds iiif_search_builder.rb to app/models'

    def inject_search_builder_behavior
      copy_file 'iiif_search_builder.rb', 'app/models/iiif_search_builder.rb'
    end
  end
end