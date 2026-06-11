Rails.application.routes.draw do
  get 'formularios/show'
  get 'formularios/responder'
  get 'avaliacoes/index'
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
    get 'resultados/index'
    get 'resultados/show'
    get 'resultados/exportar_csv'
    get 'imports/new'
    get 'imports/create'
    get 'gerenciamento/index'
    get 'formularios/new'
    get 'formularios/create'
    get 'templates/index'
    get 'templates/show'
    get 'templates/new'
    get 'templates/create'
    get 'templates/edit'
    get 'templates/update'
    get 'templates/destroy'
    root "gerenciamento#index"
    
    resources :imports, only: [:new, :create]
    resources :templates
    resources :formularios, only: [:new, :create]
    
    resources :resultados, only: [:index, :show] do
      get 'exportar_csv', on: :member
    end
  end
end