module V1
  module MediaTypes
    class Post < Praxis::MediaType
      identifier 'application/vnd.bloggy.post'
      description 'A Post in Bloggy'

      domain_model 'V1::Resources::Post'

      attributes do
        attribute :id, Integer,
          description: 'Unique identifier'
        attribute :href, String,
          example: proc {|o,ctx| "/api/v1.0/posts/#{o.id}"},
          description: 'Href for use with this API'

        attribute :title, String,
          example: /\w+/
        attribute :content, String,
          example: /[:sentence:]{4,5}/
        attribute :url, String,
          description: 'URL for a web browser',
          example: proc {|o,ctx| "example.com/posts/#{o.id}"}

        attribute :author, User,
          description: 'Related User resource'
        attribute :blog, Blog,
          description: 'Related Blog resource'

        attribute :timestamps do
          attribute :created_at, DateTime
          attribute :updated_at, DateTime
        end

        links do
          link :author
          link :blog
        end
      end

      view :default do
        attribute :id
        attribute :href

        attribute :title
        attribute :content
        attribute :url
        attribute :author

        attribute :timestamps
        attribute :links
      end

      view :overview do
        attribute :id
        attribute :href
        attribute :title
      end

      view :link do
        attribute :href
      end


      class CollectionSummary < Praxis::MediaType
        display_name 'PostCollectionSummary'
        attributes do
          attribute :href, String
          attribute :count, Integer
        end

        view :link do
          attribute :href
          attribute :count
        end
      end
    end
  end
end
