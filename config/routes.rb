Rails.application.routes.draw do
  resource :sessions, only: [:create, :new]
  resource :identity, only: [:create, :new]

  delete "log_out", to: "sessions#destroy", as: :log_out
  get "log_in", to: "sessions#new", as: :log_in
  get "sign_up", to: "identities#new", as: :sign_up

  namespace :otp do
    get "/", to: "configure#new", as: :new_configure
    post "/", to: "configure#create", as: :configure

    get "/complete", to: "complete#show", as: :complete

    get "/disable", to: "disable#show", as: :disable
    delete "/disable", to: "disable#destroy"

    get "/verify", to: "verify#new", as: :new_verify
    post "/verify", to: "verify#create", as: :verify
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
