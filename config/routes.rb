Rails.application.routes.draw do
  get '/dashboard',to: "user_panel#index", as: :user_panel

  get 'admin_panel',to: 'admin_panel#index',as: :admin_panel
  get 'admin_panel/users',as: :admin_users

  devise_for :users,:controllers => { sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords' }
  root 'home#home'
  get 'admin', to: 'home#admin', as: :admin
  resources :users

end
