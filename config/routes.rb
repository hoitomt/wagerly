Rails.application.routes.draw do
  root to: 'clients#index'

  resources :clients do
    resources :transactions, only: [:index, :new, :create]
    get 'audit', as: 'audit'
  end

  resources :tickets, only: [:index, :show] do
    collection do
      get 'untagged', as: 'untagged'
      get 'sync', as: 'sync'
    end
  end
  resources :ticket_tags, only: [:create, :destroy]

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'todos' => 'pages#todos'
end
