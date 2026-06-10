Rails.application.routes.draw do
  get 'passwords/edit'
  get 'passwords/update'
  
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  #tela inicial de avaliações do aluno
  root "avaliacoes#index"

  #login e logout
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  #definicao de senha
  resources :passwords, only: [:edit, :update]

  #usuario comum
  resources :avaliacoes, only: [:index]
  resources :formularios, only: [:show] do
    post 'responder', on: :member
  end

  #admin
  namespace :admin do
    root "gerenciamento#index"
    
    resources :imports, only: [:new, :create]
    resources :templates
    resources :formularios, only: [:new, :create]
    
    resources :resultados, only: [:index, :show] do
      get 'exportar_csv', on: :member
    end
  end
end