# frozen_string_literal: true

# install BlacklightIiifSearch behavior into implementing application
require 'rails/generators'

module BlacklightIiifSearch
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :search_builder_name, type: :string, default: 'search_builder'
    argument :controller_name, type: :string, default: 'catalog'

    class_option :'skip-solr', type: :boolean, default: false, desc: 'Skip generating Solr configurations.'

    desc <<-EOS
      Install generator for Blacklight IIIF Search
      This generator makes the following changes to your application:
       1. Injects behavior into CatalogController
       2. Adds a SearchBuilder to ./app/models
       3. Adds BlacklightIiifSearch routes to ./config/routes.rb
       4. Modifies solrconfig.xml to support contextual autocomplete functionality
      Thanks for installing Blacklight IIIF Search!
    EOS

    def verify_blacklight_installed
      return if IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')
      say_status('info', 'BLACKLIGHT NOT INSTALLED; GENERATING BLACKLIGHT', :blue)

      say_status('info', 'APP GEMFILE LOOKS LIKE:')
      system 'pwd'
      system 'cat ./../../../Gemfile'
      generate 'blacklight:install'
    end

    def insert_to_controllers
      generate 'blacklight_iiif_search:controller', controller_name
    end

    def insert_to_models
      generate 'blacklight_iiif_search:model', search_builder_name
    end

    def insert_to_routes
      generate 'blacklight_iiif_search:routes'
    end

    def add_solr_config
      generate 'blacklight_iiif_search:solr' unless options[:'skip-solr']
    end

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end
  end
end
