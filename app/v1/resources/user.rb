require_relative 'base'

module V1
  module Resources
    class User < Base
      model ::User

      def posts_summary
        {
          href: "#{href}/posts",
          count: posts.size
        }
      end
      
    end
  end
end
