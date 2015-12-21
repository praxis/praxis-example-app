module V1
  module ResourceDefinitions
    class Blogs
      include Praxis::ResourceDefinition

      version '1.0'
      media_type MediaTypes::Blog
      description <<-EOS
The representation of a blog. Each blog has a collection of posts,
and is owned by a user.

The API allows retrieving the list of existing blogs, getting the
details of a single one, as well as their creation and deletion.
EOS



      action :index do
        description 'Retrieve a listing of blogs.'
        routing { get '' }
        params do
          attribute :view, Symbol,
            description: "View name with which to render the Blogs. If no view " +
              "fields params are passed, Blogs will be rendered with the 'default' view."
          attribute :fields, Praxis::Types::FieldSelector.for(MediaTypes::Blog),
            description: "Fields with which to render the Blogs."
        end
        response :ok, media_type: Praxis::Collection.of(MediaTypes::Blog)
      end

      action :show do
        description 'Retrieve details for a single blog given its id.'
        routing { get '/:id' }

        params do
          attribute :id
          attribute :view, Symbol,
            description: "View name with which to render the Blog. If no view " +
              "fields params are passed, Blog will be rendered with the 'default' view."
          attribute :fields, Praxis::Extensions::FieldSelection::FieldSelector.for(MediaTypes::Blog),
            description: "Fields with which to render the Blog."
        end

        response :ok
        response :resource_not_found
      end

      action :create do
        description 'Create a new blog.'

        routing { post '' }

        payload do
          attribute :name, required: true
          attribute :description
          attribute :tags

          attribute :owner, required: true do
            attribute :id, required: true
          end
        end

        response :created
        response :resource_not_found
      end

      action :delete do
        description "Delete a single blog by id"
        routing { delete '/:id' }
        params do
          attribute :id, required: true
        end
        response :no_content
      end

    end
  end
end
