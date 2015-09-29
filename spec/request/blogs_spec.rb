require 'spec_helper'

describe V1::Controllers::Blogs do

  let!(:blog_records) { create_list(:blog, 3, :with_posts) }
  let!(:blog_record) { blog_records.first }


  context 'index' do
    subject(:response) { last_response }

    before do
      get '/api/v1.0/blogs'
    end

    its(:status){ should be(200) }

    it 'returns the correct content type' do
      expect(response.headers['Content-Type']).to eq 'application/vnd.bloggy.blog;type=collection'
    end

    it 'returns 3 JSON encoded items' do
      parsed = JSON.parse(response.body)
      expect(parsed).to have(3).items
    end
  end


  context 'show' do
    let!(:blog) { create(:blog) }

    it 'returns the blog' do
      get "/api/v1.0/blogs/#{blog.id}"
      expect(last_response.status).to be(200)
    end

    context 'for a non-existent id' do
      it 'returns a 404 with useful error message' do
        get '/api/v1.0/blogs/1111'
        expect(last_response.status).to be(404)

        body = last_response.body
        expect(body).to eq 'Blog with id: 1111 was not found in the system'
      end

    end

  end

  context 'create' do
    let!(:user) { create(:user) }
    let(:payload) do
      {
        name: 'My Blog',
        owner: {id: user.id }
      }
    end

    it 'creates the blog' do
      post '/api/v1.0/blogs', JSON.pretty_generate(payload), 'CONTENT_TYPE' => 'application/json'

      location = last_response.headers['Location']
      blog_id = location.split('/').last

      blog = Blog[blog_id]

      expect(blog.name).to eq 'My Blog'
      expect(blog.owner.id).to eq user.id
    end

    context 'for non-existent user' do
      it 'returns a 404 with useful error message' do
        payload[:owner][:id] = 1112

        post '/api/v1.0/blogs', JSON.pretty_generate(payload), 'CONTENT_TYPE' => 'application/json'
        expect(last_response.status).to be(404)

        body = last_response.body
        expect(body).to eq 'User with id: 1112 was not found in the system'
      end

    end
  end

  context 'delete' do

    before do
      delete "/api/v1.0/blogs/#{blog_record.id}"
    end

    subject(:response) { last_response }

    its(:status) { should eq(204) }

    it 'deletes the blog' do
      blog = Blog[blog_record.id]
      expect(blog).to be nil
    end

  end

end
