Rails.application.routes.draw do
  resources :drivers
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :drivers, only: [:create]
      resources :trucks, only: [:index]
      # resources :assignments

      post "sign_in", to: "drivers#sign_in"
      put "drivers/assign_truck", to: "drivers#assign_truck"
      get 'drivers/trucks', to: "drivers#trucks"

    end
  end
end