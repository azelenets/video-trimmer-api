require 'rails_helper'

RSpec.describe 'routes for Users' do
  describe 'POST v1/sign_in' do
    it 'should route to Devise:Sessions#create' do
      expect(post: user_session_path).to route_to(controller: 'devise/sessions', action: 'create', format: :json)
    end
  end

  describe 'DELETE v1/sign_out' do
    it 'should route to Devise:Sessions#destroy' do
      expect(delete: destroy_user_session_path).to route_to(controller: 'devise/sessions', action: 'destroy', format: :json)
    end
  end
end