Rails.application.routes.draw do
  root "welcome#index"

  resources :merchants

  resources :items, except: [:new, :create]

  resources :reviews, only: [:edit, :update, :destroy]

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items do
    resources :reviews, only: [:new, :create]
  end

  resources :cart, only: [:index, :destroy, :update]
  delete "/cart", to: "cart#empty"

  get "/login", to: "sessions#new"
  resources :login, controller: :sessions, only: [:create]
  get "/logout", to: "sessions#destroy"

  resources :password, controller: :passwords, only: [:edit, :update]

  resources :item_orders, only: [:show, :update]

  resources :orders, only: [:create, :new, :show, :update]

  resources :register, controller: :users, only: [:index, :create]

  resources :profile, only: [:index, :edit, :update]

  namespace :profile do
    root "profile#index"
    root "cart#index"
    resources :orders, only: [:index, :show]
  end

  namespace :merchant do
    root "dashboard#index"
    resources :orders, only: [:show, :update]
    resources :items
  end

  namespace :admin do
    root "dashboard#index"
    resources :merchants, only: [:show, :update, :index]
    resources :orders, only: [:update]
    resources :profile, controller: :profile, only: [:show]
    resources :users, controller: :profile, only: [:index, :show]
  end

end
