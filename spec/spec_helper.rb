require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
Bundler.setup :default, :test

require 'praxis'
require 'rack/test'
require 'rspec/its'
require 'rspec/collection_matchers'
require 'pry'

require 'praxis-mapper/support/factory_girl'

ENV['RACK_ENV'] = 'test'
Dir["#{File.dirname(__FILE__)}/support/*.rb"].each do |file|
  require file
end

Praxis::Blueprint.caching_enabled = true

require_relative '../config/initializers/000_praxis_mapper'
require_relative '../lib/database_helper'
# Ensure we setup the database *before* loading the models
# TODO: figure out if there isn't a way to tell Sequel to
# re-introspect the database.
DatabaseHelper.setup!(DB)

FULL_APP = Rack::Builder.parse_file('config.ru').first

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  def app
    FULL_APP
  end

  config.before(:suite) do
    FactoryGirl.find_definitions
    DB.transaction do
      FactoryGirl.lint
      raise Sequel::Rollback
    end
  end

  config.around(:each) do |example|
    DB.transaction do
      example.run
      raise Sequel::Rollback
    end
  end

  config.before(:each) do
    Praxis::Blueprint.cache = Hash.new do |hash, key|
      hash[key] = Hash.new
    end
  end

end
