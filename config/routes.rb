Rails.application.routes.draw do
  devise_for :customers

  get "about", to: "about#index"

  root to: "home#index"

  resources :products, only: %i[index show]

  post "products/add_to_cart/:id", to: "products#add_to_cart", as: :add_to_cart

  delete "products/remove_from_cart/:id", to: "cart#remove_from_cart", as: :remove_from_cart

  resources :cart, only: %i[index]

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
