Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  resources :users, only: [:new, :create]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#delete'
  patch '/cart/:item_id', to: 'cart#update'

  resources :items, only: [:index]

  namespace :merchant do
    get '/:id/dashboard', to: 'dashboard#index', as: :dashboard
    resources :discounts, shallow: true
    resources :items, except: [:destroy], shallow: true
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: [:update]
  end

  # resources :merchants do
  #   scope module: "merchants" do
  #     resources :discounts, shallow: true
  #     resources :items, only: :update
  #     resources :items, except: [:destroy], shallow: true
  #     resources :invoices, only: [:index, :show]
  #     resources :invoice_items, only: [:update]
  #   end
  # end

  namespace :admin, shallow: true do
    get '/', to: 'dashboard#index'
    resources :merchants
    resources :invoices, only: [:index, :show, :update]
  end
end
