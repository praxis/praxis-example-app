require 'sequel/plugins/serialization'

# Setup databae connection based on RACK_ENV. Substitute
# with any other Sequel connection you need.
case ENV['RACK_ENV']
when 'test'
  DB = Sequel.sqlite
else
  DB = Sequel.connect('sqlite://bloggy.sqlite', max_connections: 2)
end


Praxis::Mapper::ConnectionManager.setup do
  repository(:default,
    query: Praxis::Mapper::Query::Sequel,
    factory: Praxis::Mapper::ConnectionFactories::Sequel,
    opts: {connection: DB}
  )
end
