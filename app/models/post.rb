# Low-level Sequel::Model for posts

class Post < Sequel::Model
  include Praxis::Mapper::SequelCompat

  plugin :serialization, :json

  serialize_attributes :json, :timestamps

  # Define author with an eager_loader proc so we can
  # use Post.eager(:author) and have the same author object
  # for every post.
  many_to_one :author, class: :User,
  eager_loader: proc { |eo_opts|
    eo_opts[:rows].each {|post| post.associations[:author] = nil}

    id_map = eo_opts[:id_map]
    users = User.where(id: id_map.keys)
    users.each do |user|
      user.associations[:posts] ||= []
      posts = id_map[user.id]
      posts.each do |post|
        post.associations[:author] = user
        user.associations[:posts] << post
      end
    end
  }

  many_to_one :blog, class: :Blog
end
