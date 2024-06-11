require 'sidekiq/web'


Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :users,only: [:index,:destroy]

  resources :daily_records, only: [:index]
end
