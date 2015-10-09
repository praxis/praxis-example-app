# Posts is an example controller that uses Sequel models
# directly for interacting with the database.

module V1
  module Controllers
    class Posts
      include Base
      include Praxis::Extensions::Rendering

      implements ResourceDefinitions::Posts

      def index(*args)
        posts = Post.all

        display(posts)
      end


      def show(id:, **args)
        post = Post[id]
        if post.nil?
          return ResourceNotFound.new(id: id, type: Post)
        end

        display(post)
      end


      def create(blog_id: nil, **args)
        post_data = request.payload.part 'post'

        post = ::Post.create(
           title: post_data.body.title,
           content: post_data.body.content,
           blog_id: post_data.body.blog.id
        )

        response = Praxis::Responses::Created.new

        location = ResourceDefinitions::Posts.to_href(id: post.id)
        response.headers['Location'] = location

        response
      end

      def delete(id:)
        post = Post[id]
        if post.nil?
          return ResourceNotFound.new(id: id, type: Post)
        end

        post.delete

        Praxis::Responses::NoContent.new
      end

    end
  end
end
