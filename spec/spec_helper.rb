# frozen_string_literal: true

# testing environent:
ENV['RAILS_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear!

# engine_cart:
require 'bundler/setup'
require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
