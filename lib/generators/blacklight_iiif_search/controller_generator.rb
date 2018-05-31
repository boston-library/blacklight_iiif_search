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
      unless IO.read("app/controllers/#{controller_name}_controller.rb").include?('BlacklightIiifSearch')
        marker = 'include Blacklight::Catalog'
        insert_into_file "app/controllers/#{controller_name}_controller.rb", after: marker do
          "\n\n  # CatalogController-scope behavior and configuration for BlacklightIiifSearch
  include BlacklightIiifSearch::Controller\n\n"
        end
        marker = 'configure_blacklight do |config|'
        insert_into_file "app/controllers/#{controller_name}_controller.rb", after: marker do
          "\n    # configuration for Blacklight IIIF Content Search
    config.iiif_search = {
      full_text_field: 'all_text_timv',
      object_relation_field: 'is_page_of_ssim',
      fragsize: 100,
      snippets: 10,
      supported_params: %w[q page]
    }\n\n"
        end
      end
    end
  end
end
