# Low-level Sequel::Model for users

class User < Sequel::Model
  include Praxis::Mapper::SequelCompat

  one_to_many :posts, key: :author_id

  one_to_many :blogs, class: :Blog
end