# Blogs is an example controller that uses Sequel models
# via praxis-mapper for interacting with the database.

require_relative 'base'

module V1
  module Controllers
    class Users
      include Base
      implements ResourceDefinitions::Users


      def index(*args)
        user_records = identity_map.load(User) do
          track :primary_blog
          track :posts
        end

        identity_map.finalize!

        users = user_records.collect do |user_record|
          MediaTypes::User.from(user_record)
        end

        response.headers['Content-Type'] = self.media_type.identifier # or: 'application/vnd.bloggy.user; type=collection'
        response.body = users.collect { |user| user.render(view: :extended) }

        response
      end


      def show(id:, **args)
        user_record = identity_map.load(User) do
          where id: id
          track :primary_blog
          track :posts
        end.first
        identity_map.finalize!

        if user_record.nil?
          return ResourceNotFound.new(id: id, type: User)
        end

        response.headers['Content-Type'] = self.media_type.identifier # or:  'application/vnd.bloggy.user'

        user = MediaTypes::User.from(user_record)
        response.body = user.render(view: :extended)

        response
      end


    end
  end
end
