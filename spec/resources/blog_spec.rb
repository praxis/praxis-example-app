require 'spec_helper'

describe V1::Resources::Blog do

  let(:post_count) { 10 }
  let!(:blog_record) { FactoryGirl.create(:blog, :with_posts, post_count: post_count) }
  subject(:blog_resource) { V1::Resources::Blog.new(blog_record) }

  it 'converts timestamps to DateTimes' do
    expect(blog_resource.timestamps[:updated_at]).to be_kind_of(DateTime)
    expect(blog_resource.timestamps[:created_at]).to be_kind_of(DateTime)
  end

  it 'sorts and limits recent_posts'do
    expected = blog_resource.posts.sort do |a,b|
      a.timestamps[:created_at] <=> b.timestamps[:created_at]
    end[0..4]
    expect(blog_resource.recent_posts).to eq(expected)
  end

end
