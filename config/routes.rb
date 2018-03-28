Rails.application.routes.draw do
  resources :users, path: 'profiles', only: [:show, :create, :update] do
    resource :password,
      controller: :passwords, only: [:create, :edit, :update]
  end

  resources :passwords, only: [:create, :new]

  controller :users do
    get "applications", action: :applications
    get "applications/all", action: :index
    get "signup", action: :new
  end

  resource :session, only: [:create]
  controller :sessions do
    get "login", action: :new
    delete "logout", action: :destroy
  end

  resources :cohorts

  constraints Clearance::Constraints::SignedIn.new { |user| user.is_admin? } do
    root to: "users#applications", as: :admin_root
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: "users#show", as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "sessions#new"
  end
end
