require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  authenticated :user do
    root to: 'campaigns#index', as: :authenticated_root
    # root to: redirect('/campaigns') # show the path
  end

  # mount Sidekiq::Web => '/sidekiq'

  root to: 'pages#home'
  resources :campaigns, except: [:new] do
    post 'raffle', on: :member
    # post 'raffle', on: :collection
  end

  get 'members/:token/opened', to: 'members#opened'
  resources :members, only: [:create, :destroy, :update]
end
