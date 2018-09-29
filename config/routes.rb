Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/auth/login', to: 'auth#login', as: 'login'
  post '/auth/logout', to: 'auth#logout', as: 'logout'
  post '/auth/refresh', to: 'auth#refresh_token', as: 'refresh_token'
  get '/user_timers', to: 'timer#user_timers', as: 'user_timers'

  resources :users, only: :create
  resources :timer, only: :create
end
