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

# APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
# load 'rails/tasks/engine.rake'

# load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

# require 'rake/testtask'

# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib'
#   t.libs << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = false
# end

load 'tasks/blacklight_iiif_search.rake'

task default: :ci

require 'engine_cart/rake_task'
EngineCart.fingerprint_proc = EngineCart.rails_fingerprint_proc

require 'solr_wrapper'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

desc 'Run test suite'
task ci: ['engine_cart:generate'] do # TODO add rubocop
  SolrWrapper.wrap do |solr|
    solr.with_collection do
      within_test_app do
        system 'RAILS_ENV=test rake blacklight_iiif_search:index:seed'
      end
      Rake::Task['spec'].invoke
    end
  end
end
