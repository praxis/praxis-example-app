require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, ENV['RACK_ENV'])

require 'praxis/tasks'

task :default => :spec

# load up the Praxis app
task :environment do
  Praxis::Application.instance.setup
end

desc "console"
task :console => :environment do
  require 'pry'
  require 'pry-byebug'
  pry
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

Dir["lib/tasks/**/*.rake"].each { |ext| load ext }

namespace :db do
  desc 'setup the database'
  task :setup => :environment do
      DatabaseHelper.setup!(DB)
  end

  desc 'seed with example data'
  task :seed => :environment  do
    FactoryGirl.find_definitions

    user = FactoryGirl.create :user

    10.times.collect do
      FactoryGirl.create :blog, :with_posts, owner: user
    end

  end
end
