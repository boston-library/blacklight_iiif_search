source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'coveralls', require: false
end

# To use a debugger
# gem 'byebug', group: [:development, :test]

# BEGIN ENGINE_CART BLOCK
# engine_cart: 2.5.0
# engine_cart stanza: 2.5.0
# the below comes from engine_cart, a gem used to test this Rails engine gem in the context of a Rails app.
file = File.expand_path('Gemfile', ENV.fetch('ENGINE_CART_DESTINATION') { ENV.fetch('RAILS_ROOT') { File.expand_path('.internal_test_app', File.dirname(__FILE__)) } })
if File.exist?(file)
  begin
    eval_gemfile file
  rescue Bundler::GemfileError => e
    Bundler.ui.warn '[EngineCart] Skipping Rails application dependencies:'
    Bundler.ui.warn e.message
  end
else
  Bundler.ui.warn "ENGINE_CART_DESTINATION: #{ENV.fetch('ENGINE_CART_DESTINATION') { 'ENGINE_CART_DESTINATION NOT SET' }}"
  Bundler.ui.warn "RAILS_ROOT: #{ENV.fetch('RAILS_ROOT') { 'RAILS_ROOT NOT SET' }}"
  Bundler.ui.warn "FILE EXPAND PATH = #{File.expand_path('.internal_test_app', File.dirname(__FILE__))}"
  Bundler.ui.warn "CURRENT DIR: #{system 'pwd'}"
  Bundler.ui.warn "WHAT IS IN INTERNAL_TEST_APP: #{system('ls ' + file.split('/')[0..-2].join('/'))}"
  Bundler.ui.warn "[EngineCart] Unable to find test application dependencies in #{file}, using placeholder dependencies"
  if ENV['RAILS_VERSION']
    if ENV['RAILS_VERSION'] == 'edge'
      gem 'rails', github: 'rails/rails'
      ENV['ENGINE_CART_RAILS_OPTIONS'] = '--edge'
    else
      gem 'rails', ENV['RAILS_VERSION']
    end
  end
end
# END ENGINE_CART BLOCK

# eval_gemfile File.expand_path("spec/test_app_templates/Gemfile.extra", File.dirname(__FILE__))
