# frozen_string_literal: true

require 'rubygems'
require 'rails'
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
task ci: ['engine_cart:generate'] do
  SolrWrapper.wrap do |solr|
    # single-term autocomplete via tokenizing-suggest currently requires Solr 7.*, see README.md for more info
    if solr.version.to_f < 8
      FileUtils.cp(File.join(__dir__, 'lib', 'generators', 'blacklight_iiif_search', 'templates', 'solr', 'lib', 'tokenizing-suggest-v1.0.1.jar'),
                   File.join(solr.instance_dir, 'contrib'))
    end
    solr.with_collection do
      within_test_app do
        system 'RAILS_ENV=test rake blacklight_iiif_search:index:seed'
      end
      Rake::Task['spec'].invoke
    end
  end
end
