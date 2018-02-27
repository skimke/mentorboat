Rails.application.routes.draw do
  resources :users, path: 'profiles', only: [:create] do
    resource :password,
      controller: :passwords, only: [:create, :edit, :update]
  end

  resources :passwords, only: [:create, :new]

  resource :session, only: [:create]
  
  controller :sessions do
    get "log_in", action: :new
    delete "log_out", action: :destroy
  end

  get "sign_up", controller: :users, action: :new
end
