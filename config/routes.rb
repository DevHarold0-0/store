Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :products
  root "products#index"
end
