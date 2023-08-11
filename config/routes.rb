Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :drivers, only: [:create]

      post "sign_in", to: "drivers#sign_in"
      resources :trips


    end
  end
end