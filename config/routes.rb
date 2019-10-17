Rails.application.routes.draw do
  devise_for :users,
  controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations' ,
  omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'products#index'

  resources :products ,only: [:new,]
end
