require_relative 'base'

module V1
  module Resources
    class User < Base
      model ::User

      property :posts_summary, dependencies: [:href, :posts]
      property :blogs_summary, dependencies: [:href, :blogs]

      def posts_summary
        {
          href: "#{href}/posts",
          count: posts.size
        }
      end

      def blogs_summary
        {
          href: "#{href}/blogs",
          count: blogs.size
        }
      end

      def recent_posts
        @recent_posts ||= posts.sort do |a,b|
          a.timestamps[:created_at] <=> b.timestamps[:created_at]
        end[0..4]
      end


    end
  end
end
