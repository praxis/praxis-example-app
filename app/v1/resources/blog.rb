require_relative 'base'

module V1
  module Resources
    class Blog < Base
      model ::Blog

      property :recent_posts, dependencies: ['posts.timestamps']
      property :posts_summary, dependencies: [:href, :posts]

      def recent_posts
        @recent_posts ||= posts.sort do |a,b|
          a.timestamps[:created_at] <=> b.timestamps[:created_at]
        end[0..4]
      end


      def posts_summary
        {
          href: "#{href}/posts",
          count: posts.size
        }
      end
    end
  end
end
