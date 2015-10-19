# Blogs is an example controller that uses Sequel models
# via praxis-mapper for interacting with the database.

require_relative 'base'

module V1
  module Controllers
    class Blogs
      include Base

      include Praxis::Extensions::MapperSelectors
      include Praxis::Extensions::Rendering

      implements ResourceDefinitions::Blogs

      before actions: [:index, :show] do |controller|
        controller.set_selectors
      end

      def index(*args)
        blog_records = identity_map.load(Blog)
        identity_map.finalize!

        
        display(blog_records)
      end


      def show(id:, **args)
        blog = identity_map.load(Blog) do
          where id: id
        end.first
        identity_map.finalize!

        if blog.nil?
          return ResourceNotFound.new(id: id, type: Blog)
        end

        display(blog)
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
