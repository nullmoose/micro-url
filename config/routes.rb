Rails.application.routes.draw do
  root 'links#new'

  resources :links, only: [:create]

  get   '/l/:short_slug',        to: 'links#show',   as: :short
  get   '/a/:admin_slug',        to: 'links#admin',  as: :admin
  patch '/a/:admin_slug/expire', to: 'links#expire', as: :expire
end
