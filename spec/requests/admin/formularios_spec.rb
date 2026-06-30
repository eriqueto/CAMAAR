require 'rails_helper'

RSpec.describe "Admin::Formularios", type: :request do
  before(:each) do
    @admin = Pessoa.create!(usuario: 'rivaldo', email: 'rivaldo@unb.br', nome: 'Rivaldo Ferreira', password: '123', password_confirmation: '123', admin: true)
    post login_path, params: { identificacao: 'rivaldo@unb.br', password: '123' }

    @template = Template.create!(nome: 'Avaliação de Sistemas Operacionais', pessoa: @admin)
    TemplateQuestao.create!(template: @template, enunciado: 'Pergunta do template', tipo_resposta: :texto)
    
    docente = Docente.create!(pessoa: @admin)
    disciplina = Disciplina.create!(codigo: 'CIC0111', nome: 'Sistemas Operacionais')
    @turma = Turma.create!(codigo: 'TA', disciplina: disciplina, docente: docente)
  end

  describe "POST /admin/formularios" do
    context "Happy Path" do
      it "cria o formulário para as turmas marcadas usando o template" do
        post admin_formularios_path, params: { 
          template_id: @template.id, 
          turma_ids: [@turma.id] 
        }
        
        expect(Formulario.count).to eq(1)
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:notice]).to eq("Formulário criado e vinculado às turmas com sucesso.")
      end
    end

    context "Sad Path" do
      it "bloqueia o envio se nenhuma turma for selecionada" do
        post admin_formularios_path, params: { 
          template_id: @template.id, 
          turma_ids: [] 
        }
        
        expect(flash[:alert]).to include("Ocorreu um erro ao gerar os formulários:")
      end
    end
  end
end