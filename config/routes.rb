Rails.application.routes.draw do
  root 'home#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  
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
  
  namespace :admin do
    resources :championships do
      member do
        post :generate_rounds
        post :add_club
        delete :remove_club
      end
    end
    
    resources :clubs
    
    resources :users do
      member do
        patch :toggle_admin
        patch :toggle_active
      end
    end
    
    resources :rounds, only: [] do
      get :matches, on: :member
      post :create_matches, on: :member
      get :results, on: :member
      post :update_results, on: :member
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end
