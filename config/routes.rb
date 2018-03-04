Rails.application.routes.draw do
  resources :users, path: 'profiles', only: [:create] do
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
end
