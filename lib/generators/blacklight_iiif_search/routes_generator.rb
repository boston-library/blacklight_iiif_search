require 'rails/generators'

module BlacklightIiifSearch
  class RoutesGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc """
  This generator makes the following changes to your application:
   1. Injects route declarations into your routes.rb
         """

    # Add CommonwealthVlrEngine to the routes
    def inject_iiif_search_routes
      unless IO.read("config/routes.rb").include?('CommonwealthVlrEngine::Engine')
        marker = 'Rails.application.routes.draw do'
        insert_into_file "config/routes.rb", :after => marker do
          %q{

  concern :iiif_search, BlacklightIiifSearch::Routes.new
}
        end

        # for blacklight_range_limit
        bl_routes_marker = /resources :solr_documents[\S\s]*concerns :exportable.*$/
        inject_into_file 'config/routes.rb', after: bl_routes_marker do
          "\n    concerns :iiif_search\n"
        end

      end
    end

  end
end