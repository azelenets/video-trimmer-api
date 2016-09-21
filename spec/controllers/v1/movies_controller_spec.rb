require 'rails_helper'

RSpec.describe V1::MoviesController do
  let!(:user) { create(:user) }
  # let!(:auth_headers) { { 'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token } }
  # before { request.env.merge!(auth_headers)  }

  describe '#index' do
    it 'responds with success' do
      process :index, method: :get, params: { user_email: user.email, user_token: user.authentication_token }
      expect(response).to have_http_status(:success)
    end
  end
end
