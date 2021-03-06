Rails.application.routes.draw do

  resources :charges, only: [:new, :create, :destroy]

  resources :wikis



  resources :collaborators, only: [:create, :new]

  devise_for :users

  resources :users, only: [:show]

  get "welcome/index"

  root 'welcome#index'

end
