Rails.application.routes.draw do
  # Cria todas as rotas padrão para templates (index, show, new, create, edit, update, destroy)
  resources :templates
  
  get "up" => "rails/health#show", as: :rails_health_check
end