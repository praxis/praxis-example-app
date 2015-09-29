Praxis::Application.configure do |application|

  # Use Rack::ContentLength middleware
  application.middleware Rack::ContentLength

  # Use Praxis::Handlers::XML for 'xml'-type parsing/generating
  application.handler 'xml', Praxis::Handlers::XML

  # Ensure we validate responses
  application.config.praxis.validate_responses = true

  # Configure application layout
  application.layout do
    map :initializers, 'config/initializers/**/*'
    map :lib, 'lib/**/*'
    map :design, 'design/' do
      map :api, 'api.rb'
      map :media_types, '**/media_types/**/*'
      map :resources, '**/resources/**/*'
    end
    map :app, 'app/' do
      map :models, 'models/**/*'
      map :resources, '**/resources/**/*'
      map :controllers, '**/controllers/**/*'
      map :responses, '**/responses/**/*'
    end
  end

end

Praxis::Blueprint.caching_enabled = true
