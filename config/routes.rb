Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resource :profile, only: [:show, :edit, :update], controller: 'users'
  resources :plants do
    resources :chats, only: [:create, :show] do
      resources :messages, only: [:create]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
