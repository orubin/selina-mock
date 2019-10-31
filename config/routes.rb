Rails.application.routes.draw do

  root to: 'locations#index'

  get 'order/:id', to: 'orders#index'
  resources :orders, only: :index

  namespace :api do
    namespace :v1, defaults: { format: 'json' } do
      post 'check_rooms', to: 'orders#check_rooms'
      post 'book_room', to: 'orders#book_room'
      # resources :orders, only: :index
    end
  end

end
