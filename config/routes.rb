Rails.application.routes.draw do
  devise_for :users, only: :sessions, path: '/', defaults: { format: :json }
end
