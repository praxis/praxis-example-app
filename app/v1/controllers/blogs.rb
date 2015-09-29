# Blogs is an example controller that uses Sequel models
# via praxis-mapper for interacting with the database.

require_relative 'base'

module V1
  module Controllers
    class Blogs
      include Base

      implements ResourceDefinitions::Blogs

      def index(*args)
        # this action returns a collection of resources, so ensure
        # we set the Content-Type header appropriately
        response.headers['Content-Type'] = self.content_type + ";type=collection"
        blogs = identity_map.load(Blog) do
          load :owner
          track :posts
        end

        identity_map.finalize!

        blog_resources = V1::Resources::Blog.wrap(blogs)
        rendered = blog_resources.collect do |blog_resource|
          mt = MediaTypes::Blog.new(blog_resource)
          mt.render(view: :default)
        end

        JSON.pretty_generate(rendered)
      end


      def show(id:, **args)
        blog = identity_map.load(Blog) do
          where id: id
          load :owner, :posts
        end.first

        if blog.nil?
          return ResourceNotFound.new(id: id, type: Blog)
        end

        blog_resource = V1::Resources::Blog.wrap(blog)
        media_type = MediaTypes::Blog.new(blog_resource)

        response.headers['Content-Type'] = self.content_type

        JSON.pretty_generate(media_type.render(view: :default))
      end


      def create(**args)
        owner_id = request.payload.owner.id
        owner = identity_map.load(User) do
          where id: owner_id
        end.first

        if owner.nil?
          return ResourceNotFound.new(id: owner_id, type: User)
        end

        blog = Blog.new(
          owner: owner,
          name: request.payload.name,
          description: request.payload.description
        )
        identity_map.attach(blog)

        response = Praxis::Responses::Created.new
        location = ResourceDefinitions::Blogs.to_href(id: blog.id)
        response.headers['Location'] = location
        response
      end

      def delete(id:)
        blog = identity_map.load(Blog) do
          where id: id
        end.first

        if blog.nil?
          return ResourceNotFound.new(id: id, type: Blog)
        end

        identity_map.remove(blog)

        Praxis::Responses::NoContent.new
      end

    end
  end
end
