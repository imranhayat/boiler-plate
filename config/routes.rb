# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    root to: 'users/sessions#new'
  end
  get '/change_access', to: 'admin_panel#change_access', as: :change_access
  get '/dashboard', to: 'user_panel#index', as: :user_panel
  get 'profile', to: 'user_panel#profile', as: :profile
  get '/edit_profile', to: 'user_panel#edit_profile', as: :edit_profile
  get 'top_up', to: 'user_panel#top_up', as: :top_up
  post 'payment', to: 'user_panel#payment', as: :payment
  get 'admin_panel', to: 'admin_panel#index', as: :admin_panel
  get 'admin_panel/users', as: :admin_users
  devise_for :users,
             controllers: { sessions: 'users/sessions',
                            registrations: 'users/registrations',
                            passwords: 'users/passwords',
                            invitations: 'users/invitations',
                            omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: %i[edit update]
  post 'stripe-webhooks', to: 'home#webhooks'
end
