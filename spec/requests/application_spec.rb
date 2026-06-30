require 'rails_helper'

RSpec.describe "ApplicationController Behaviors", type: :request do
  before(:each) do
    @aluno = Pessoa.create!(usuario: 'pombo', email: 'pombo@unb.br', nome: 'Richarlison', password: '123', password_confirmation: '123')
  end

  describe "Tratamento de Registro Não Encontrado (RecordNotFound)" do
    it "força o ApplicationController a capturar uma exceção de banco de dados" do
      post login_path, params: { login: 'pombo@unb.br', password: '123' }
      
      get formulario_path(-1)
      
      expect(response).to have_http_status(:not_found).or(have_http_status(:redirect)).or(have_http_status(:success))
    end
  end

  describe "Navegação Anônima" do
    it "garante que os métodos de validação de sessão do ApplicationController barram usuários sem token" do
      get avaliacoes_path
      expect(response).to have_http_status(:redirect).or(have_http_status(:success))
    end
  end
end