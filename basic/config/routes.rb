Rails.application.routes.draw do

  get 'login', to: 'user_sessions#new', as: :login
  post 'logout', to: 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:new, :create, :destroy]

end
