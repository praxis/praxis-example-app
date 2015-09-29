module V1
  module MediaTypes
    class User < Praxis::MediaType
      identifier 'application/vnd.bloggy.user'

      attributes do
        attribute :id, Integer
        attribute :href, String,
          example: proc {|o,ctx| "/api/v1.0/users/#{o.id}"}

        attribute :first, String, example: /[:first_name:]/
        attribute :last, String, example: /[:last_name:]/
        attribute :posts, Attributor::Collection.of(Post)

        attribute :timestamps do
          attribute :created_at, DateTime
          attribute :updated_at, DateTime
        end

        attribute :posts_summary, Post::CollectionSummary,
          example: proc { |user,ctx| Post::CollectionSummary.example(ctx, href: "#{user.href}/posts") }

        links do
          link :posts, using: :posts_summary
        end

      end

      view :default do
        attribute :id
        attribute :href

        attribute :first
        attribute :last
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
