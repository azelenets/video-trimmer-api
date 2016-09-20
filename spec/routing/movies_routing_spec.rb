require 'rails_helper'

describe 'routes for Movies' do
  context 'v1 index' do
    it 'should route to V1:Movies#index' do
      expect(get: v1_movies_path).to route_to(controller: 'v1/movies', action: 'index')
    end
  end
end
