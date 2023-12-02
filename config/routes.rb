Rails.application.routes.draw do
  resources :products do
    collection do
      get 'index_by_category/:category_id', action: :index_by_category, as: 'index_category'
    end
  end

  devise_for :customers, controllers: { sessions: "customers/sessions" }

  get "about", to: "about#index"

  root to: "home#index"

  get "search", to: "search#search"

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
