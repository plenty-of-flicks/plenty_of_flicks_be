Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      # services routes
      get '/services/update_availability', to: 'services#update_availability'
      get '/services/update_all_availabilities', to: 'services#update_all_availabilities'
      resources :services

      # movies routes
      get '/movies/populate_details', to: 'movies#populate_details'
      get '/movies/random_available', to: 'movies#random_available'
      resources :movies

      # users routes
      get '/users/:id/friends', to: 'users#friends'
      resources :users, only: [:create, :show, :update] do
        resources :friendships, only: [:create]
        resources :groups, only: [:index]
      end

      # groups routes
      get '/groups/:id/matches', to: 'groups#matches'
      resources :groups, only: [:create, :destroy, :show]

      # user_groups routes
      resources :user_groups, only: [:create, :destroy]

      # swipes routes
      resources :swipes, only: [:create]
    end
  end
end
