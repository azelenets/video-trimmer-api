Rails.application.routes.draw do
  devise_for :users, only: :sessions, path: '/', path_prefix: 'v1', defaults: { format: :json }

  api_version(module: 'V1', path: { value: 'v1' }, defaults: { format: :json }) do
  end
end
