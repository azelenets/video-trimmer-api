require 'rails_helper'

RSpec.describe 'routes for Movies' do
  let!(:movie) { create(:movie) }

  describe 'GET v1/movies' do
    it 'should route to V1:Movies#index' do
      expect(get: v1_movies_path).to route_to(controller: 'v1/movies', action: 'index', format: :json)
    end
  end

  describe 'POST v1/movies' do
    it 'should route to V1:Movies#index' do
      expect(post: v1_movies_path).to route_to(controller: 'v1/movies', action: 'create', format: :json)
    end
  end

  describe 'GET v1/movie/:id' do
    it 'should route to V1:Movies#show' do
      expect(get: v1_movie_path(movie)).to route_to(controller: 'v1/movies', action: 'show', id: movie.id.to_s, format: :json)
    end
  end

  describe 'PATCH v1/movie/:id' do
    it 'should route to V1:Movies#update' do
      expect(patch: v1_movie_path(movie)).to route_to(controller: 'v1/movies', action: 'update', id: movie.id.to_s, format: :json)
    end
  end

  describe 'PUT v1/movie/:id' do
    it 'should route to V1:Movies#update' do
      expect(put: v1_movie_path(movie)).to route_to(controller: 'v1/movies', action: 'update', id: movie.id.to_s, format: :json)
    end
  end

  describe 'DELETE v1/movie/:id' do
    it 'should route to V1:Movies#destroy' do
      expect(delete: v1_movie_path(movie)).to route_to(controller: 'v1/movies', action: 'destroy', id: movie.id.to_s, format: :json)
    end
  end
end
