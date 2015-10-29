Praxis::ApiDefinition.define do |api|

  # Applies to all API versions
  api.info do
    name "bloggy"
    title "A Blog API example application"
    description "This is a longer description about what this API service is all about"
    version_with :path
    base_path '/api/v:api_version'
    consumes 'json', 'x-www-form-urlencoded', 'form-data', 'xml'
    produces 'json', 'form-data', 'xml'
  end

  # Applies to 1.0 version
  # Also inherits everything else form the global one
  api.info("1.0") do
    description "This is the 1.0 version of Bloggy"
  end

  api.response_template :resource_not_found do
    description "The requested API resource could not be found for the provided :id"
    status 404
  end

end