Rails.application.routes.draw do
  resources :clients
  resources :tickets, only: [:index, :show] do
    collection do
      get 'untagged', as: 'untagged'
    end
  end
  resources :ticket_tags, only: [:create, :destroy]
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'
  get 'todos' => 'pages#todos'
end
