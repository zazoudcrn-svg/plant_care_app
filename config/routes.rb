Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :plants do
    resources :chats, only: [:create, :show, :destroy] do
      resources :messages, only: [:create]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
