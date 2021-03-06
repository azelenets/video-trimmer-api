require 'rails_helper'
require 'airborne'

RSpec.describe V1::MoviesController do
  let!(:user) { create(:user) }
  let!(:movie) { create(:movie, user: user) }

  context 'auth via params' do
    describe '#index' do
      it 'responds with success status and have correct data types/values' do
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
        expect_json('data.?.links', self: v1_movie_path(reloaded_movie))
      end
    end

    describe '#show' do
      it 'responds with success status and have correct data types/values' do
        process :show, method: :get, params: { user_email: user.email, user_token: user.authentication_token, id: movie.id.to_s }
        expect(response).to have_http_status(:success)
        expect_json_types(data: :object)
        expect_json_types('data', type: :string, id: :string, attributes: :object, links: :object)
        expect_json_types('data.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :float, file: :string)
        expect_json_types('data.links', self: :string)
        reloaded_movie = movie.reload
        expect_json('data.attributes',
                    state: reloaded_movie.human_state_name,
                    'start-time': reloaded_movie.start_time.strftime('%H:%M:%S'),
                    'end-time': reloaded_movie.end_time.strftime('%H:%M:%S'),
                    duration: reloaded_movie.duration,
                    file: reloaded_movie.file.url)
        expect_json('data.links', self: v1_movie_path(reloaded_movie))
      end
    end

    describe '#create' do
      context 'success' do
        it 'responds with created status and have correct data types/values' do
          process :create, method: :post,
                  params: { user_email: user.email,
                            user_token: user.authentication_token,
                            movie: {
                                start_time: '00:00:01',
                                end_time: '00:00:06',
                                file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_example.mp4'), 'video/mp4')
                            }
                  }
          expect_status(:created)
          expect_json_types(data: :object)
          expect_json_types('data', type: :string, id: :string, attributes: :object, links: :object)
          expect_json_types('data.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :null, file: :null)
          expect_json_types('data.links', self: :string)
          movie = Movie.last
          expect_json('data.attributes',
                      state: 'scheduled',
                      'start-time': '00:00:01',
                      'end-time': '00:00:06',
                      duration: nil,
                      file: nil)
          expect_json('data.links', self: v1_movie_path(movie))
        end
      end

      context 'errors' do
        it 'responds with unprocessable_entity status and process errors for file, start time, end time' do
          process :create, method: :post,
                  params: { user_email: user.email,
                            user_token: user.authentication_token,
                            movie: { start_time: nil, end_time: nil }
                  }
          expect_status(:unprocessable_entity)
          expect_json_types(errors: :array_of_objects)
          expect_json_types('errors.*', source: :object, detail: :string)
          expect_json_types('errors.?.source', pointer: :string)
          expect_json('errors.?', detail: "File can't be blank")
          expect_json('errors.?.source', pointer: '/data/attributes/file')
          expect_json('errors.?', detail: "Start time can't be blank")
          expect_json('errors.?.source', pointer: '/data/attributes/start-time')
          expect_json('errors.?', detail: "End time can't be blank")
          expect_json('errors.?.source', pointer: '/data/attributes/end-time')
        end

        it 'responds with unprocessable_entity status and process errors if start time bigger than end time' do
          process :create, method: :post,
                  params: { user_email: user.email,
                            user_token: user.authentication_token,
                            movie: {
                                start_time: '00:00:06',
                                end_time: '00:00:01',
                                file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_example.mp4'), 'video/mp4')
                            }
                  }
          expect_status(:unprocessable_entity)
          expect_json_types(errors: :array_of_objects)
          expect_json_types('errors.*', source: :object, detail: :string)
          expect_json_types('errors.?.source', pointer: :string)
          expect_json('errors.?', detail: "Start time can't be greater than end time")
          expect_json('errors.?.source', pointer: '/data/attributes/start-time')
        end
      end
    end

    describe '#update (restart)' do
      let(:failed_movie) { create(:movie, user: user, state: Movie.state_machine.states[:failed].value) }

      context 'success' do
        it 'responds with created status and have correct data types/values' do
          process :update, method: :put,
                  params: { user_email: user.email, user_token: user.authentication_token, id: failed_movie.id.to_s }
          expect_status(:created)
          expect_json_types(data: :object)
          expect_json_types('data', type: :string, id: :string, attributes: :object, links: :object)
          expect_json_types('data.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :null, file: :null)
          expect_json_types('data.links', self: :string)
          expect_json('data.attributes',
                      state:        'scheduled',
                      'start-time': failed_movie.start_time.strftime('%H:%M:%S'),
                      'end-time':   failed_movie.end_time.strftime('%H:%M:%S'),
                      duration:     nil,
                      file:         nil)
          expect_json('data.links', self: v1_movie_path(failed_movie))
        end
      end

      context 'errors' do
        it 'responds with created status and have correct data types/values' do
          process :update, method: :put,
                  params: { user_email: user.email, user_token: user.authentication_token, id: movie.id.to_s }
          expect_status(:unprocessable_entity)
          expect_json_types(errors: :array_of_objects)
          expect_json_types('errors.*', source: :object, detail: :string)
          expect_json_types('errors.?.source', pointer: :string)
          expect_json('errors.?', detail: "State cannot transition via \"restart\"")
          expect_json('errors.?.source', pointer: '/data/attributes/state')
        end
      end
    end

    describe '#destroy' do
      context 'success' do
        it 'responds with created status' do
          process :destroy, method: :delete,
                  params: { user_email: user.email, user_token: user.authentication_token, id: movie.id.to_s }
          expect_status(:no_content)
        end
      end

      context 'errors' do
        it 'responds with not found status' do
          process :destroy, method: :delete,
                  params: { user_email: user.email, user_token: user.authentication_token, id: 'nonexistent-record-id' }
          expect_status(:not_found)
          expect_json_types(errors: :array_of_objects)
          expect_json('errors.?', detail: 'Document(s) not found for class Movie with id(s) nonexistent-record-id.')
        end
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

    describe '#show' do
      it 'responds with success and have correct data types/values' do
        process :show, method: :get, params: { id: movie.id.to_s }
        expect(response).to have_http_status(:success)
        expect_json_types(data: :object)
        expect_json_types('data', type: :string, id: :string, attributes: :object, links: :object)
        expect_json_types('data.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :float, file: :string)
        expect_json_types('data.links', self: :string)
        reloaded_movie = movie.reload
        expect_json('data.attributes',
                    state: reloaded_movie.human_state_name,
                    'start-time': reloaded_movie.start_time.strftime('%H:%M:%S'),
                    'end-time': reloaded_movie.end_time.strftime('%H:%M:%S'),
                    duration: reloaded_movie.duration,
                    file: reloaded_movie.file.url)
        expect_json('data.links', self: v1_movie_path(reloaded_movie))
      end
    end

    describe '#create' do
      context 'success' do
        it 'responds with created status and have correct data types/values' do
          process :create, method: :post,
                  params: { movie: {
                                start_time: '00:00:01',
                                end_time: '00:00:06',
                                file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_example.mp4'), 'video/mp4')
                            }
                  }
          expect_status(:created)
          expect_json_types(data: :object)
          expect_json_types('data', type: :string, id: :string, attributes: :object, links: :object)
          expect_json_types('data.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :null, file: :null)
          expect_json_types('data.links', self: :string)
          movie = Movie.last
          expect_json('data.attributes',
                      state: 'scheduled',
                      'start-time': '00:00:01',
                      'end-time': '00:00:06',
                      duration: nil,
                      file: nil)
          expect_json('data.links', self: v1_movie_path(movie))
        end
      end

      context 'errors' do
        it 'responds with unprocessable_entity status and process errors for file, start time, end time' do
          process :create, method: :post,
                  params: { movie: { start_time: nil, end_time: nil }
                  }
          expect_status(:unprocessable_entity)
          expect_json_types(errors: :array_of_objects)
          expect_json_types('errors.*', source: :object, detail: :string)
          expect_json_types('errors.?.source', pointer: :string)
          expect_json('errors.?', detail: "File can't be blank")
          expect_json('errors.?.source', pointer: '/data/attributes/file')
          expect_json('errors.?', detail: "Start time can't be blank")
          expect_json('errors.?.source', pointer: '/data/attributes/start-time')
          expect_json('errors.?', detail: "End time can't be blank")
          expect_json('errors.?.source', pointer: '/data/attributes/end-time')
        end

        it 'responds with unprocessable_entity status and process errors if start time bigger than end time' do
          process :create, method: :post,
                  params: { movie: {
                                start_time: '00:00:06',
                                end_time: '00:00:01',
                                file: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_example.mp4'), 'video/mp4')
                            }
                  }
          expect_status(:unprocessable_entity)
          expect_json_types(errors: :array_of_objects)
          expect_json_types('errors.*', source: :object, detail: :string)
          expect_json_types('errors.?.source', pointer: :string)
          expect_json('errors.?', detail: "Start time can't be greater than end time")
          expect_json('errors.?.source', pointer: '/data/attributes/start-time')
        end
      end
    end

    describe '#update (restart)' do
      let(:failed_movie) { create(:movie, user: user, state: Movie.state_machine.states[:failed].value) }

      context 'success' do
        it 'responds with created status and have correct data types/values' do
          process :update, method: :put, params: { id: failed_movie.id.to_s }
          expect_status(:created)
          expect_json_types(data: :object)
          expect_json_types('data', type: :string, id: :string, attributes: :object, links: :object)
          expect_json_types('data.attributes', state: :string, 'start-time': :string, 'end-time': :string, duration: :null, file: :null)
          expect_json_types('data.links', self: :string)
          expect_json('data.attributes',
                      state:        'scheduled',
                      'start-time': failed_movie.start_time.strftime('%H:%M:%S'),
                      'end-time':   failed_movie.end_time.strftime('%H:%M:%S'),
                      duration:     nil,
                      file:         nil)
          expect_json('data.links', self: v1_movie_path(failed_movie))
        end
      end

      context 'errors' do
        it 'responds with created status and have correct data types/values' do
          process :update, method: :put, params: { id: movie.id.to_s }
          expect_status(:unprocessable_entity)
          expect_json_types(errors: :array_of_objects)
          expect_json_types('errors.*', source: :object, detail: :string)
          expect_json_types('errors.?.source', pointer: :string)
          expect_json('errors.?', detail: "State cannot transition via \"restart\"")
          expect_json('errors.?.source', pointer: '/data/attributes/state')
        end
      end
    end

    describe '#destroy' do
      context 'success' do
        it 'responds with created status' do
          process :destroy, method: :delete, params: { id: movie.id.to_s }
          expect_status(:no_content)
        end
      end

      context 'errors' do
        it 'responds with not found status' do
          process :destroy, method: :delete, params: { id: 'nonexistent-record-id' }
          expect_status(:not_found)
          expect_json_types(errors: :array_of_objects)
          expect_json('errors.?', detail: 'Document(s) not found for class Movie with id(s) nonexistent-record-id.')
        end
      end
    end
  end
end


