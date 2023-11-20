Rails.application.routes.draw do
  get 'home/index'
  get "about", to: "about#index"

  root to: "home#index"

  resources :products, only: %i[index show]

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
