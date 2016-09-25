Rails.application.routes.draw do
  apipie
  devise_for :users,
             only: :sessions,
             controllers: { sessions: 'v1/sessions' },
             path: '/',
             path_prefix: 'v1',
             defaults: { format: :json }

  api_version(module: 'V1', path: { value: 'v1' }, defaults: { format: :json }) do
    resources :movies
  end
end
