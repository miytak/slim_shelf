Rails.application.routes.draw do
  resources :artists, only: %w(index show)
  get '/search', to: 'search#index'
end
