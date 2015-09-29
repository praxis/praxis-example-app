require 'spec_helper'

describe 'media types' do

  context 'posts' do
    before do
      FactoryGirl.create(:post)
    end

    it 'renders' do
      post_model = Post.first
      post_resource = V1::Resources::Post.wrap(post_model)

      post_media_type = V1::MediaTypes::Post.load(post_resource)

      post_media_type.render(view: :default)
    end
  end

  context 'blog' do
    before do
      FactoryGirl.create(:blog)
    end

    it 'renders' do
      blog_model = Blog.first
      blog_resource = V1::Resources::Blog.wrap(blog_model)
      blog_media_type = V1::MediaTypes::Blog.load(blog_resource)
      blog_media_type.render(view: :default)
    end
  end

  context 'user' do
    before do
      FactoryGirl.create(:user)
    end

    it 'renders' do
      user_model = User.first
      user_resource = V1::Resources::User.wrap(user_model)
      user_media_type = V1::MediaTypes::User.load(user_resource)

      user_media_type.render(view: :summary)
    end
  end
end
