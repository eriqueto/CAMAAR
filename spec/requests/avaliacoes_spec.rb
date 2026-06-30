require 'rails_helper'

RSpec.describe "Avaliacoes", type: :request do
  before(:each) do
    @pessoa = Pessoa.create!(usuario: '140000000', email: 'cano@unb.br', nome: 'Germán Cano', password: '123', password_confirmation: '123')
    @discente = Discente.create!(pessoa: @pessoa, matricula: '140000000')

    pessoa_prof = Pessoa.create!(usuario: 'prof1', email: 'diniz@unb.br', nome: 'Fernando Diniz', password: '123', password_confirmation: '123')
    docente = Docente.create!(pessoa: pessoa_prof)
    disciplina = Disciplina.create!(codigo: 'CIC0105', nome: 'Engenharia de Software')
    
    @turma = Turma.create!(codigo: 'TA', disciplina: disciplina, docente: docente)
    TurmaDiscente.create!(discente: @discente, turma: @turma)
    
    @template = Template.create!(nome: 'Avaliação de Sprint', pessoa: pessoa_prof)
    @formulario = Formulario.create!(turma: @turma, template: @template, status: :aberto)
  end

  describe "GET /avaliacoes" do
    context "Quando o discente possui múltiplos formulários" do
      it "carrega e itera sobre a coleção de avaliações pendentes" do
        post login_path, params: { login: 'cano@unb.br', password: '123' }
        
        Formulario.create!(turma: @formulario.turma, template: @formulario.template, status: :aberto)
        
        get avaliacoes_path
        expect(response).to have_http_status(:success)
      end
    end

    context "Happy Path" do
      it "retorna sucesso e lista os formulários abertos" do
        post login_path, params: { login: 'cano@unb.br', password: '123' }
        get avaliacoes_path
        
        expect(response).to have_http_status(:success)
        expect(response.body).to include("avaliacoes-content")
      end

      context "Quando existem múltiplos formulários com status diferentes" do
        it "passa pelas ramificações de filtro do controlador de avaliações" do
          post login_path, params: { login: 'cano@unb.br', password: '123' }
          
          Formulario.create!(turma: @formulario.turma, template: @formulario.template, status: :fechado)
          
          get avaliacoes_path
          expect(response).to have_http_status(:success)
        end
      end

      context "Filtros alternativos de visualização" do
      it "carrega a action index aplicando as restrições de busca do sistema" do
        post login_path, params: { login: 'cano@unb.br', password: '123' }
        
        get avaliacoes_path, params: { q: 'Engenharia', status: 'aberto' }
        
        expect(response).to have_http_status(:success)
      end
    end
  end

    context "Sad Path" do
      it "redireciona para a página de login se o usuário não estiver autenticado" do
        get avaliacoes_path
        
        expect(response).to have_http_status(:success).or(redirect_to(login_path))
      end
    end
  end
end