Rails.application.routes.draw do
  # ActiveAdmin routes
  ActiveAdmin.routes(self)
  
  # Devise routes for users
  devise_for :users
  
  # Page routes
  get '/about', to: 'pages#show', defaults: { slug: 'about' }
  get '/contact', to: 'pages#show', defaults: { slug: 'contact' }
  
  # Cart routes
  get 'cart', to: 'cart#show'
  post 'cart/add/:product_id', to: 'cart#add', as: 'add_to_cart'
  delete 'cart/remove/:product_id', to: 'cart#remove', as: 'remove_from_cart'
  patch 'cart/update/:product_id', to: 'cart#update', as: 'update_cart_quantity'
  delete 'cart/clear', to: 'cart#clear', as: 'clear_cart'
  get 'cart/test_add/:product_id', to: 'cart#test_add', as: 'test_add_to_cart'
  
  # Checkout routes
  get 'checkout', to: 'checkout#new'
  post 'checkout', to: 'checkout#create'
  
  # Order confirmation route
  get 'order_confirmation/:id', to: 'checkout#show', as: 'order_confirmation'
  
  # Order routes for users
  resources :orders, only: [:index, :show]
  
  # Category routes
  resources :categories, only: [:show]
  
  # Public product routes
  resources :products, only: [:index, :show]
  
  # Homepage
  root to: 'products#index'
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
