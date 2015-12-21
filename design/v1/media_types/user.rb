module V1
  module MediaTypes
    class User < Praxis::MediaType
      identifier 'application/vnd.bloggy.user'
      description 'A Bloggy User'

      domain_model 'V1::Resources::User'

      attributes do
        attribute :id, Integer
        attribute :href, String,
          example: proc {|o,ctx| "/api/v1.0/users/#{o.id}"}

        attribute :first, String, example: /[:first_name:]/
        attribute :last, String, example: /[:last_name:]/
        attribute :recent_posts, Attributor::Collection.of(Post),
          description: 'Collection of the 10 recent posts for the user.'

        attribute :blogs, Attributor::Collection.of(Blog)

        attribute :primary_blog, Blog,
          description: 'The primary blog for the user, the default for new posts.'


        attribute :timestamps do
          attribute :created_at, DateTime
          attribute :updated_at, DateTime
        end

        attribute :posts_summary, Post::CollectionSummary,
          example: proc { |user,ctx| Post::CollectionSummary.example(ctx, href: "#{user.href}/posts") }

        attribute :blogs_summary, Blog::CollectionSummary,
          example: proc { |user,ctx| Blog::CollectionSummary.example(ctx, href: "#{user.href}/blogs") }

        links do
          link :primary_blog
          link :posts, using: :posts_summary
          link :blogs, using: :blogs_summary
        end

      end

      view :default do
        attribute :id
        attribute :href
        attribute :first
        attribute :last

        attribute :timestamps

        attribute :links
      end

      view :overview do
        attribute :id
        attribute :href
        attribute :first
        attribute :last

        attribute :links
      end

      view :extended do
        attribute :id
        attribute :href

        attribute :first
        attribute :last

        attribute :primary_blog, view: :overview
        attribute :recent_posts, view: :overview

        attribute :links
      end

      view :link do
        attribute :href
      end

      view :summary do
        attribute :links
      end
    end
  end
end
