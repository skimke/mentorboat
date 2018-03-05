Rails.application.routes.draw do
  resources :users, path: 'profiles', only: [:show, :create, :update] do
    resource :password,
      controller: :passwords, only: [:create, :edit, :update]
  end

  resources :passwords, only: [:create, :new]

  resource :session, only: [:create]
  
  controller :sessions do
    get "login", action: :new
    delete "logout", action: :destroy
  end

  get "signup", controller: :users, action: :new

  constraints Clearance::Constraints::SignedOut.new do
    root to: "sessions#new"
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: "users#show", as: :signed_in_root
  end
end
