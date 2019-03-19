# adds controller-scope behavior to the implementing application
require 'rails/generators'

module BlacklightIiifSearch
  class ControllerGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :controller_name, type: :string, default: 'catalog'

    desc "
  This generator makes the following changes to your app's CatalogController:
   1. Includes BlacklightIiifSearch::Controller
   2. Adds some basic configuration settings in the configure_blacklight block
         "

    # Update the blacklight catalog controller
    def inject_catalog_controller_behavior
      return if IO.read("app/controllers/#{controller_name}_controller.rb").include?('BlacklightIiifSearch')
      marker = 'configure_blacklight do |config|'
      inject_into_file "app/controllers/#{controller_name}_controller.rb", before: marker do
        "  # CatalogController-scope behavior and configuration for BlacklightIiifSearch
  include BlacklightIiifSearch::Controller\n\n  "
      end
      inject_into_file "app/controllers/#{controller_name}_controller.rb", after: marker do
        "\n\n    # configuration for Blacklight IIIF Content Search
    config.iiif_search = {
      full_text_field: 'text',
      object_relation_field: 'is_page_of_s',
      supported_params: %w[q page],
      autocomplete_handler: 'iiif_suggest',
      suggester_name: 'iiifSuggester'
    }\n"
      end
    end
  end
end
