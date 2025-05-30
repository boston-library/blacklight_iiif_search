# frozen_string_literal: true

# insert routing for IIIF Content Search
require 'rails/generators'

module BlacklightIiifSearch
  class RoutesGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'This generator makes the following changes to your app:
        1. Injects route declarations into your routes.rb'

    # Add BlacklightIiifSearch to the routes
    def inject_iiif_search_routes
      return if IO.read('config/routes.rb').include?('BlacklightIiifSearch::Routes')

      marker = 'Rails.application.routes.draw do'
      inject_into_file 'config/routes.rb', after: marker do
        "\n\n  concern :iiif_search, BlacklightIiifSearch::Routes.new"
      end
      # for blacklight_range_limit
      bl_routes_marker = /resources :solr_documents[\S\s]*controller: 'catalog' do[\s]*concerns :exportable.*$/
      inject_into_file 'config/routes.rb', after: bl_routes_marker do
        "\n    concerns :iiif_search"
      end
    end
  end
end
