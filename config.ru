# -p 9292

ENV['RACK_ENV'] ||= 'development'
Bundler.setup(:default, ENV['RACK_ENV'])
Bundler.require(:default, ENV['RACK_ENV'])

# Uncomment the below to enable New Relic developer mode.
# See https://docs.newrelic.com/docs/agents/ruby-agent/developer-mode/developer-mode
# for more.
#require 'new_relic/rack/developer_mode'
#use NewRelic::Rack::DeveloperMode

# Uncomment the below to avoid 404 errors when using the New Relic developer mode.
#map "/favicon.ico" do
#  run lambda { |_env| [200, {}, ['']] }
#end

run Praxis::Application.instance.setup
