Rails.application.routes.draw do
  # Re-written routes file for Mod 3 Intermission work.
  # Original routes are commented out above their re-written counterparts.

  # resources :reviews, only: [:edit, :update, :destroy]
  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  puts '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  # resources :orders, only: [:new, :update]
  get '/orders/new', to: 'orders#new'
  patch '/orders/:id', to: 'orders#update'
  puts '/orders/:id', to: 'orders#update'

  # resources :items, except: [:new, :create] do
  #   resources :reviews, only: [:new, :create]
  # end
  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show'
  get '/items/:id/edit', to: 'items#edit'
  patch '/items/:id', to: 'items#update'
  puts '/items/:id', to: 'items#update'
  delete '/items/:id', to: 'items#destroy'
  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  # resources :merchants
  get '/merchants', to: 'merchants#index'
  get '/merchants/new', to: 'merchants#new'
  post '/merchants', to: 'merchants#create'
  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  puts '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'

  # Unmodified non-RESTful route
  get "/", to: "home#index"

  # Unmodified non-RESTful routes
  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  # post "/users/:id/orders", to: "orders#create"
  resources :users, except: [:index, :show, :edit, :update, :new, :create, :destroy] do
    resources :orders, only: [:create]
  end

  # get "/profile/orders/:order_id", to: "orders#show"
  # get '/profile/orders', to: 'orders#index'
  scope 'profile' do
    resources :orders, only: [:show, :index]
  end

  # get "/register", to: "users#new"
  resource :register, path: '/', only: [:new], controller: 'users', path_names: { new: 'register'}

  # post "/register", to: "users#create"
  resource :register, controller: 'users', only: [:create]

  # get "/profile", to: "users#show"
  # get "/profile/edit", to: "users#edit"
  # patch "/profile", to: "users#update"
  resource :profile, only: [:show, :edit, :update], controller: 'users'

  # Unmodified non-RESTful routes
  get "/profile/edit_password", to: "users#edit_password"
  patch "/profile/edit_password", to: "users#update_password"

  # Unmodified non-RESTful routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Unmodified non-RESTful routes
  post '/coupon', to: 'coupon#add'
  delete '/coupon', to: 'coupon#remove'

  namespace :merchant do
    # Unmodified non-RESTful routes
    get '/', to: 'dashboard#index'
    patch '/items/:id/activation', to: 'items#activate'

    # resources :items, except: [:show]
    get '/items', to: 'items#index'
    get '/items/new', to: 'items#new', as: 'item_new'
    post '/items', to: 'items#create', as: 'item_create'
    get '/items/:id/edit', to: 'items#edit', as: 'item_edit'
    patch '/items/:id/edit', to: 'items#update', as: 'item_update'
    delete '/items/:id', to: 'items#destroy'

    # resources :item_orders, only: [:update]
    patch '/item_orders/:id', to: 'item_orders#update'

    # resources :orders, only: [:show]
    get '/orders/:id', to: 'orders#show'

    # resources :coupons
    get '/coupons', to: 'coupons#index'
    get '/coupons/new', to: 'coupons#new'
    post '/coupons', to: 'coupons#create', as: 'coupon_create'
    get '/coupons/:id', to: 'coupons#show'
    get '/coupons/:id/edit', to: 'coupons#edit'
    patch '/coupons/:id', to: 'coupons#update', as: 'coupon_update'
    delete '/coupons/:id', to: 'coupons#destroy', as: 'coupon_delete'
  end

  namespace :admin do
    # resources :merchants, only: [:show]
    get '/merchants/:id', to: 'merchants#show'

    # Unmodified non-RESTful routes
    get '/', to: 'dashboard#index'
    patch '/merchants/:id/:enable_disable', to: 'merchants#update'

    # resources :users, only: [:index, :show, :edit, :update] do
    #   resources :orders, only: [:index, :show]
    # end
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    get '/users/:id/edit', to: 'users#edit'
    patch '/users/:id', to: 'users#update', as: 'user'
    get '/users/:user_id/orders', to: 'orders#index'
    get '/users/:user_id/orders/:id', to: 'orders#show'

    # Unmodified non-RESTful routes
    get '/users/:id/edit_password', to: 'users#edit_password'
    patch '/users/:id/edit_password', to: 'users#update_password'
  end

  # get "/merchants/:merchant_id/items", to: "items#index"
  resources :merchants, except: [:index, :show, :edit, :update, :new, :create, :destroy] do
    resources :items, only: [:index]
  end
end
