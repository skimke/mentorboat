Rails.application.routes.draw do
  resources :users, only: [:create] do
    resource :password,
      controller: :passwords, only: [:create, :edit, :update]
  end

  resources :passwords, only: [:create, :new]

  resource :session, only: [:create]
  
  controller :sessions do
    get "sign_in", action: :new
    delete "sign_out", action: :destroy
  end

  get "sign_up", controller: :users, action: :new
end
