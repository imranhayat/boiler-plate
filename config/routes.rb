Rails.application.routes.draw do
  get '/dashboard',to: "user_panel#index", as: :user_panel
  get 'profile',to: "user_panel#profile",as: :profile
  get 'top_up',to: "user_panel#top_up",as: :top_up
  # get 'payment',to: "user_panel#payment",as: :payment
  post 'payment',to: "user_panel#payment",as: :payment
  get 'admin_panel',to: 'admin_panel#index',as: :admin_panel
  get 'admin_panel/users',as: :admin_users

  devise_for :users,:controllers => { sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords' }
  # resources :users

  post 'stripe-webhooks',to: 'home#webhooks'

  root 'home#index'
end
