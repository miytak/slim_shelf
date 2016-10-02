Rails.application.routes.draw do
  resources :artists, only: %w(index show)
  resources :cds, only: %w(index) do
    get :search, on: :collection
  end
end
