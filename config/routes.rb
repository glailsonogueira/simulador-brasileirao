Rails.application.routes.draw do
  root 'home#index'
  
  # Autenticacao
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # OAuth Google
  get '/auth/google_oauth2/callback', to: 'omniauth_callbacks#google_oauth2'
  get '/auth/failure', to: 'omniauth_callbacks#failure'
  post '/auth/google_oauth2', to: 'omniauth_callbacks#google_oauth2'
  
  # Previsoes
  resources :rounds, only: [:show]
  resources :predictions, only: [:index] do
    collection do
      patch 'update_batch'
    end
  end
  
  # Rankings
  get 'rankings', to: 'rankings#index'
  get 'rankings/round/:id', to: 'rankings#round', as: :round_rankings
  get 'rankings/user/:id', to: 'rankings#user_detail', as: :user_detail_rankings
  
  # Admin
  namespace :admin do
    resources :championships do
      member do
        post :activate
        post :generate_rounds
      end
      post 'add_club', to: 'championships#add_club'
      delete 'remove_club/:club_id', to: 'championships#remove_club', as: :remove_club
    end
    resources :clubs
    resources :users do
      member do
        patch :toggle_admin
        patch :toggle_active
      end
    end
    resources :rounds, only: [] do
      resources :matches
      resources :results, only: [:index, :update] do
        collection do
          post :recalculate
        end
      end
    end
  end
end
