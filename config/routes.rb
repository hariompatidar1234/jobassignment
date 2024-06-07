require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :users,only: [:index,:destroy]

  resources :daily_records, only: [:index]
end
