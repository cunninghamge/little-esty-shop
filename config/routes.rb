Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  resources :users, only: [:new, :create]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#delete'
  patch '/cart/:item_id', to: 'cart#update'

  resources :items, only: [:index]
  resources :invoices, only: [:create]

  namespace :merchant, shallow: true do
    get '/:id/dashboard', to: 'dashboard#index', as: :dashboard
    patch '/:id/items/:id/enable', to: 'items#enable', as: :item_enable
    resources :discounts
    resources :items, except: [:destroy]
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: [:update]
  end

  namespace :admin, shallow: true do
    get '/', to: 'dashboard#index'
    patch '/merchants/:id/enable', to: 'merchants#enable', as: :merchant_enable
    resources :merchants
    resources :invoices, only: [:index, :show, :update]
  end
end
