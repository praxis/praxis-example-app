require 'spec_helper'

describe 'models' do

  context 'factories' do

    let(:post_count) { 3 }
    before do
      FactoryGirl.create(:user, :with_posts, post_count: post_count)
    end

    context ':user, :with_posts' do
      it 'uses the post_count attribute' do
        expect(Post.all).to have(post_count).items
      end
    end

    context 'used through Sequel' do
      it 'preserves object identity in associations with eager loading' do
        posts = Post.eager(:author).all
        post   = posts.first

        expect(post).to be(post.author.posts.first)

        post_resource = V1::Resources::Post.new(post)
        post_mt = V1::MediaTypes::Post.new(post_resource)

        #binding.pry

        expect(post_mt.validate).to be_empty
      end

      it 'does not preserve object identity without eager loading' do
        posts = Post.all
        post  = posts.first

        expect(post).to_not be(post.author.posts.first)

        post_resource = V1::Resources::Post.new(post)
        post_mt = V1::MediaTypes::Post.new(post_resource)

        # Will infinitely recurse during validation due to the
        # circular reference between the post's author, and the
        # author's posts.
        #
        # Praxis can catch cases like these, but only if an identity
        # map is used to ensure post.author.posts ends up with
        # the original post object, and not a duplicate.
        expect {
          post_mt.validate
        }.to raise_error(SystemStackError)
      end
    end

    context 'used with Praxis::Mapper' do
      let(:identity_map) { Praxis::Mapper::IdentityMap.new }

      it 'preserves object identity' do
        posts = identity_map.load Post do
          load :author
        end
        post = posts.first

        expect(post).to be(post.author.posts.first)

        post_resource = V1::Resources::Post.new(post)
        post_mt = V1::MediaTypes::Post.new(post_resource)

        expect(post_mt.validate).to be_empty
      end


    end

  end

end
