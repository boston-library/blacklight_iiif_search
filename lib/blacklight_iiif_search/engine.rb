# frozen_string_literal: true

module BlacklightIiifSearch
  class Engine < ::Rails::Engine
    isolate_namespace BlacklightIiifSearch

    # Load rake tasks.
    rake_tasks do
      Dir.chdir(File.expand_path(File.join(File.dirname(__FILE__), '..'))) do
        Dir.glob(File.join('railties', '*.rake')).each do |railtie|
          load railtie
        end
      end
    end
  end
end
