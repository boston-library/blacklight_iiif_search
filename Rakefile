begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BlacklightIiifSearch'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

Rake::Task.define_task(:environment)

load 'lib/railties/blacklight_iiif_search.rake'

task default: :ci

require 'engine_cart/rake_task'

require 'solr_wrapper'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

desc 'Run test suite'
task ci: ['engine_cart:generate'] do # TODO: add rubocop
  SolrWrapper.wrap do |solr|
    solr.with_collection do
      within_test_app do
        system 'RAILS_ENV=test rake blacklight_iiif_search:index:seed'
      end
      Rake::Task['spec'].invoke
    end
  end
end
