Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    resources :home, only: [:index]
    resources :time_slots, only: [:create, :index]
    resources :appointments, only: [:create, :index]
  end
end
