Rails.application.routes.draw do

  resources :charges, only: [:new, :create, :destroy]

  resources :wikis

  devise_for :users

  get "welcome/index"

  root 'welcome#index'

end
