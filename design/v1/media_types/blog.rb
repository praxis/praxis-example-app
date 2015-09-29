module V1
  module MediaTypes
    class Blog < Praxis::MediaType
      identifier 'application/vnd.bloggy.blog'
      description "A Bloggy Blog"

      attributes do
        attribute :id, Integer,
          description: 'Unique identifier'
        attribute :name, String,
          description: 'Short name'
        attribute :href, String,
          example: proc {|o,ctx| "/api/v1.0/blogs/#{o.id}"},
          description: 'Href for use with this API'
        attribute :description, String,
          description: 'Longer description'
        attribute :url, String,
          example: proc {|o,ctx| "example.com/blogs/#{o.id}"},
          description: 'URL for a web browser'

        attribute :timestamps do
          attribute :created_at, DateTime
          attribute :updated_at, DateTime
        end

        attribute :tags, Attributor::Collection.of(String),
          description: 'Array of tags'

        attribute :recent_posts, Praxis::Collection.of(Post),
          description: 'Array of recent related Post resources'
        attribute :owner, User,
          description: 'Related User resource'

        attribute :posts_summary,
          Post::CollectionSummary,
          example: proc { |blog,ctx| Post::CollectionSummary.example(ctx, href: "#{blog.href}/posts") },
          description: "Summary of information from related Post resources"

        links do
          link :posts, using: :posts_summary
          link :owner
        end
      end

      view :default do
        attribute :id
        attribute :href
        attribute :name
        attribute :description
        attribute :url
        attribute :timestamps

        attribute :owner
        attribute :links
      end

      view :link do
        attribute :href
      end

      class CollectionSummary < Praxis::MediaType
        attributes do
          attribute :href, String,
            description: 'API href for collection'
        end

        view :link do
          attribute :href
        end
      end
    end

  end
end
