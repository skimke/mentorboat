Rails.application.routes.draw do
  get "signup", to: "users#new"
  resources :users, path: 'profiles', only: [:index, :show, :create, :edit, :update] do
    resource :password, controller: :passwords, only: [:create, :edit, :update]
  end

  resources :passwords, only: [:create, :new]

  resource :session, only: [:create]
  controller :sessions do
    get "login", action: :new
    delete "logout", action: :destroy
  end

  controller :applications do
    get "applications/preview", action: :preview_applications
    get "applications", action: :applications
    get "applications/:user_id", action: :show, as: :application
    get "applications/:user_id/approve", action: :approve, as: :approve_application
    patch "applications/:user_id", action: :update
  end

  resources :cohorts
  resources :relationships, only: [:update] do
    get "pair/:user_id", action: :show, as: :pair
  end

  constraints Clearance::Constraints::SignedIn.new { |user| user.is_admin? } do
    root to: "applications#preview_applications", as: :admin_root
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: "cohorts#index", as: :signed_in_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "sessions#new"
  end
end
