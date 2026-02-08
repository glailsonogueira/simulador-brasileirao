Rails.application.routes.draw do
  root 'home#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  
  # Rotas de reset de senha
  resources :password_resets, only: [:new, :create], param: :token do
    member do
      get :edit
      patch :update
    end
  end

  # Rotas de conta do usuário
  namespace :account do
    resource :password, only: [:edit, :update], controller: 'passwords'
  end

  get '/auth/google_oauth2/callback', to: 'omniauth_callbacks#google_oauth2'
  get '/auth/failure', to: 'omniauth_callbacks#failure'
  post '/auth/google_oauth2', to: 'omniauth_callbacks#google_oauth2'
  
  get 'predictions', to: 'predictions#index'
  get 'championship/:championship_id/predictions', to: 'predictions#show_championship', as: :championship_predictions
  get 'championship/:championship_id/round/:round_id', to: 'rounds#show', as: :round_prediction
  patch 'championship/:championship_id/predictions/update_batch', to: 'predictions#update_batch', as: :update_batch_predictions
  
  get 'rankings', to: 'rankings#index'
  get 'championship/:championship_id/ranking', to: 'rankings#show_championship', as: :championship_rankings
  get 'championship/:championship_id/round/:round_id/ranking', to: 'rankings#round', as: :round_rankings
  get 'championship/:championship_id/user/:user_id/ranking', to: 'rankings#user_detail', as: :user_detail_rankings
  
  resources :championships, only: [] do
    member do
      post :recalculate_all_rankings
    end
  end
  
  namespace :admin do
    resources :championships do
      member do
        patch :activate
      end
      
      # Rotas de clubes e matches
      get 'clubs', to: 'championship_clubs#index', as: :clubs
      get 'matches', to: 'championship_matches#index', as: :matches
      
      # Rotas de gerenciamento de clubes
      post :add_club
      delete 'remove_club', to: 'championships#remove_club', as: :remove_club
      post :generate_rounds
    end
    
    resources :clubs
    resources :stadiums
    
    resources :users do
      member do
        patch :toggle_admin
        patch :toggle_active
        patch :force_password_change
      end
    end
    
    resources :rounds, only: [] do
      member do
        get :matches
        post :create_matches
        get :results
        post :calculate_rankings
        post :finalize_all
        post :reopen_all
      end
      
      # Matches aninhados dentro de rounds
      resources :matches, only: [:edit, :update] do
        member do
          post :finalize
          post :reopen
        end
      end
    end
    
    # Manter matches independentes para acesso direto
    resources :matches, only: [:edit, :update] do
      member do
        post :finalize
        post :reopen
      end
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end