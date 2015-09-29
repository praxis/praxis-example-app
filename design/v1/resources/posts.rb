module V1
  module ResourceDefinitions
    class Posts
      include Praxis::ResourceDefinition

      version '1.0'
      media_type MediaTypes::Post
      description <<-EOS
The representation of a post. Each post belongs to a single blog and and is authored
by a user.

The API allows retrieving the list of existing posts, getting the
details of a single one, as well as their creation and deletion.
EOS
      action :index do
        description 'Retrieve a listing of all posts.'
        routing { get '' }
        response :ok, media_type: Praxis::Collection.of(MediaTypes::Post)
      end

      action :show do
        description 'Retrieve details for a single post by id.'
        routing { get '/:id' }
        params do
          attribute :id, required: true
        end
        response :ok
        response :resource_not_found
      end

      action :create do
        description 'Creates a new post in a blog.'
        routing { post '' }
        headers do
          header 'Content-Type', 'application/vnd.bloggy.post'
        end
        payload Praxis::Types::MultipartArray do
          part 'post',
            description: "Post data including the title and the content pieces",
            required: true do
            payload do
              attribute :title, String , required: true
              attribute :content, String, required: true
              attribute :blog, required: true do
                attribute :id, String, required: true
              end
            end
          end
          file 'image'
        end
        response :created, location: %r{^/api/v1\.0/posts/\w+}
      end

      action :delete do
        description 'Delete a single post by id'
        routing { delete '/:id' }
        params do
          attribute :id, required: true
        end
        response :no_content
      end

    end
  end
end
