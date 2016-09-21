require 'rails_helper'
require 'airborne'

RSpec.describe V1::MoviesController do
  let!(:user) { create(:user) }
  let!(:movie) { create(:movie, user: user) }

  context 'auth via params' do
    describe '#index' do
      it 'responds with success' do
        process :index, method: :get, params: { user_email: user.email, user_token: user.authentication_token }
        expect(response).to have_http_status(:success)
        expect_json_types(data: :array_of_objects)
        expect_json_types('data.*', type: :string, id: :string, attributes: :object, links: :object)
        expect_json_types('data.*.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :float, file: :string)
        expect_json_types('data.*.links', self: :string)
        expect_json('data.?', type: 'movies', id: movie.id.to_s)
        reloaded_movie = movie.reload
        expect_json('data.?.attributes',
                    state: reloaded_movie.human_state_name,
                    'start-time': reloaded_movie.start_time.strftime('%H:%M:%S'),
                    'end-time': reloaded_movie.end_time.strftime('%H:%M:%S'),
                    duration: reloaded_movie.duration,
                    file: reloaded_movie.file.url)
        expect_json('data.?.links', self: v1_movie_path(movie))
      end
    end
  end

  context 'auth via headers' do
    before do
      request.headers['X-User-Email'] = user.email
      request.headers['X-User-Token'] = user.authentication_token
    end

    describe '#index' do
      it 'responds with success' do
        process :index, method: :get
        expect(response).to have_http_status(:success)
        expect_json_types(data: :array_of_objects)
        expect_json_types('data.*', type: :string, id: :string, attributes: :object, links: :object)
        expect_json_types('data.*.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :float, file: :string)
        expect_json_types('data.*.links', self: :string)
        expect_json('data.?', type: 'movies', id: movie.id.to_s)
        reloaded_movie = movie.reload
        expect_json('data.?.attributes',
                    state: reloaded_movie.human_state_name,
                    'start-time': reloaded_movie.start_time.strftime('%H:%M:%S'),
                    'end-time': reloaded_movie.end_time.strftime('%H:%M:%S'),
                    duration: reloaded_movie.duration,
                    file: reloaded_movie.file.url)
        expect_json('data.?.links', self: v1_movie_path(movie))
      end
    end
  end
end


