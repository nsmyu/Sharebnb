Rails.application.routes.draw do
  root 'home#top'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get 'users', to: 'users/registrations#edit'
    get 'users/account', to: 'users/registrations#account'
    get 'users/profile', to: 'users/registrations#profile'
    get 'users/profile/edit', to: 'users/registrations#profile_edit'
  end

  resources :rooms
  get 'search', to: 'rooms#search'

  resources :reservations do
    member do
      get :confirm
      put :register
    end
  end
end
