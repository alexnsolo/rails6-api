Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resource :filing, only: [:create]
  resources :grant_recipients, only: [:index]
  
end
