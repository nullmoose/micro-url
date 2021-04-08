Rails.application.routes.draw do
  root 'links#new'

  resources :links, only: [:create]

  get '/a/:admin_slug', to: 'links#admin', as: :admin
end
