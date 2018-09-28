Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/auth/login', to: 'auth#login', as: 'login'
  post '/auth/logout', to: 'auth#logout', as: 'logout'
  get '/auth/refresh', to: 'auth#refresh_token', as: 'refresh_token'

  resources :users, only: :create
end
