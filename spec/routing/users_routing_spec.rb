require 'rails_helper'

RSpec.describe 'routes for Users' do
  describe 'POST v1/sign_in' do
    it 'should route to V1:Sessions#create' do
      expect(post: user_session_path).to route_to(controller: 'v1/sessions', action: 'create', format: :json)
    end
  end

  describe 'DELETE v1/sign_out' do
    it 'should route to V1:Sessions#destroy' do
      expect(delete: destroy_user_session_path).to route_to(controller: 'v1/sessions', action: 'destroy', format: :json)
    end
  end
end