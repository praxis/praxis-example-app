require 'spec_helper'

describe V1::Controllers::Users do


    let!(:user_records) { create_list(:user, 3, :with_posts, :with_primary_blog) }
    let!(:user_record) { user_records.first }


    context 'index' do
      subject(:response) { last_response }

      before do
        get '/api/v1.0/users'
      end

      its(:status){ should be(200) }

      it 'returns the correct content type' do
        expect(response.headers['Content-Type']).to eq 'application/vnd.bloggy.user; type=collection'
      end


      it 'returns 3 JSON encoded items' do
        parsed = JSON.parse(response.body)
        expect(parsed).to have(3).items

        expected_keys = ["id", "href", "first", "last", "primary_blog", "recent_posts", "links"]
        parsed.each do |user|
          record = user_records.find { |b| b.id == user['id'] }
          expect(record).to_not be(nil)
          expect(user.keys).to match_array(expected_keys)
        end
      end
    end


    context 'show' do
      let!(:user) { create(:user, :with_posts, :with_primary_blog) }

      it 'returns the user' do
        get "/api/v1.0/users/#{user.id}"
        expect(last_response.status).to be(200)
      end

      context 'for a non-existent id' do
        it 'returns a 404 with useful error message' do
          get '/api/v1.0/users/1111'
          expect(last_response.status).to be(404)

          body = last_response.body
          expect(body).to eq 'User with id: 1111 was not found in the system'
        end

      end

    end


end
