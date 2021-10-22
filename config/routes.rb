Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :parking
  put 'parking/:id/pay', to: 'parking#pay'
  put 'parking/:id/out', to: 'parking#out'
end