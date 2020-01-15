Rails.application.routes.draw do

  resources :reviews, only: [:edit, :update, :destroy]
  resources :orders, only: [:new, :update]
  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end
  resources :merchants

  get "/", to: "home#index"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  post "/users/:id/orders", to: "orders#create"
  get "/profile/orders/:order_id", to: "orders#show"
  get '/profile/orders', to: 'orders#index'

  get "/register", to: "users#new"
  post "/register", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/edit_password", to: "users#edit_password"
  patch "/profile/edit_password", to: "users#update_password"

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  post '/coupon', to: 'coupon#add'
  delete '/coupon', to: 'coupon#remove'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    patch '/items/:id/activation', to: 'items#activate'
    resources :items, except: [:show]
    resources :item_orders, only: [:update]
    resources :orders, only: [:show]
    resources :coupons
  end

  namespace :admin do
    resources :merchants, only: [:show]
    get '/', to: 'dashboard#index'
    patch '/merchants/:id/:enable_disable', to: 'merchants#update'
    resources :users, only: [:index, :show, :edit, :update] do
      resources :orders, only: [:index, :show]
    end
    get '/users/:id/edit_password', to: 'users#edit_password'
    patch '/users/:id/edit_password', to: 'users#update_password'
  end
end
