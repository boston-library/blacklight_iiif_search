# install BlacklightIiifSearch behavior into implementing application
require 'rails/generators'

module BlacklightIiifSearch
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :search_builder_name, type: :string, default: 'search_builder'
    argument :controller_name, type: :string, default: 'catalog'

    desc 'Install generator for Blacklight IIIF Search'

    def verify_blacklight_installed
      unless IO.read('app/controllers/application_controller.rb').include?('include Blacklight::Controller')
        say_status('info', 'BLACKLIGHT NOT INSTALLED; GENERATING BLACKLIGHT', :blue)
        generate 'blacklight:install'
      end
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

    def bundle_install
      Bundler.with_clean_env do
        run 'bundle install'
      end
    end
  end
end
