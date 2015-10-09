# Low-level Sequel::Model for users

class User < Sequel::Model
  include Praxis::Mapper::SequelCompat
  plugin :serialization, :json

  serialize_attributes :json, :timestamps

  one_to_many :posts, key: :author_id
  one_to_many :blogs, class: :Blog, key: :owner_id

  many_to_one :primary_blog, key: :primary_blog_id, class: :Blog
end
