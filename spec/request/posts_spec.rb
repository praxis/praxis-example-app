require 'spec_helper'

describe V1::Controllers::Posts do
  let!(:post_records) { create_list(:post, 3) }
  let(:post_record) { post_records.first }

  context 'index' do
    subject(:response) { last_response }

    before do
      get '/api/v1.0/posts'
    end

    its(:status) { should eq(200) }

    it 'returns the correct content type' do
      expect(response.headers['Content-Type']).to eq 'application/vnd.bloggy.post; type=collection'
    end

    it 'returns 3 JSON encoded items' do
      parsed = JSON.parse(response.body)
      expect(parsed).to have(post_records.size).items
    end

  end


  context "show" do
    let(:action) { resource.actions[:show] }


    it 'returns a post' do
      get "/api/v1.0/posts/#{post_record.id}"

      last_body = JSON.parse(last_response.body)
      expect(last_body['title']).to eq(post_record.title)
      expect(last_body['content']).to eq(post_record.content)
    end


    context 'for a non-existent id' do
      it 'returns a 404 with useful error message' do
        get '/api/v1.0/posts/1111'
        expect(last_response.status).to be(404)

        body = last_response.body
        expect(body).to eq 'Post with id: 1111 was not found in the system'
      end

    end
  end


  context 'create' do
    let(:post_content){ /[:sentence]/.gen }
    let(:post_title){ 'The best post ever' }

    let(:form) do
      form_data = MIME::Multipart::FormData.new

      post_data = JSON.pretty_generate(
        title: post_title,
        content: post_content,
        blog: {id: 1}
      )
      form_data.add MIME::Text.new(post_data), 'post'

      #form_data.add MIME::Image.new("not quite a binary image"), 'image'
      form_data
    end

    before do
      content_type = form.headers.get('Content-Type')
      post '/api/v1.0/posts', form.body.to_s, 'CONTENT_TYPE' => content_type
    end

    subject(:response) { last_response }

    its(:status) { should eq(201) }

    it 'creates the post' do
      location = last_response.headers['Location']
      post_id = location.split('/').last

      post = Post[post_id]

      expect(post.title).to eq(post_title)
      expect(post.content).to eq(post_content)
    end

  end


  context 'delete' do

    before do
      delete "/api/v1.0/posts/#{post_record.id}"
    end

    subject(:response) { last_response }

    its(:status) { should eq(204) }

    it 'deletes the post' do
      post = Post[post_record.id]
      expect(post).to be nil
    end

  end


end
