Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, ->(user) { user.present? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  root to: "dashboard#index"
  devise_for :users

  resources :projects do
    resources :tasks, except: [ :show ]
    post "export", on: :member
    get "progress", on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
