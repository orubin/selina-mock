Rails.application.routes.draw do

  root to: 'locations#index'

  get 'order/:id', to: 'orders#index'

  get 'admin', to: 'admin#index'

  namespace :api do
    namespace :v1, defaults: { format: 'json' } do
      post 'check_rooms', to: 'orders#check_rooms'
      post 'book_room', to: 'orders#book_room'
      post 'add_location', to: 'locations#add_location'
      # resources :orders, only: :index
    end
  end

end
