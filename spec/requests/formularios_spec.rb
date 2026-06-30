require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  before(:each) do
    @pessoa = Pessoa.create!(usuario: '101010101', email: 'ganso@unb.br', nome: 'Paulo Henrique Ganso', password: '123', password_confirmation: '123')
    @discente = Discente.create!(pessoa: @pessoa, matricula: '101010101')
    
    pessoa_prof = Pessoa.create!(usuario: 'prof2', nome: 'Gordiola', password: '123', password_confirmation: '123')
    docente = Docente.create!(pessoa: pessoa_prof)
    disciplina = Disciplina.create!(codigo: 'CIC0097', nome: 'Bancos de Dados')
    turma = Turma.create!(codigo: 'TA', disciplina: disciplina, docente: docente)
    
    template = Template.create!(nome: 'Feedback Semestral', pessoa: pessoa_prof)
    @formulario = Formulario.create!(turma: turma, template: template, status: :aberto)
    @questao = Questao.create!(formulario: @formulario, enunciado: 'Nota para a didática', tipo_resposta: :texto)

    # Simula o login antes de cada teste
    post login_path, params: { login: 'ganso@unb.br', password: '123' }
  end

  describe "GET /formularios/:id" do
    it "retorna sucesso ao acessar o formulário" do
      get formulario_path(@formulario)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /formularios/:id/responder" do
    context "Happy Path" do
      it "salva as respostas com sucesso e redireciona para a raiz" do
        post responder_formulario_path(@formulario), params: { 
          respostas: { @questao.id.to_s => "O professor domina o assunto!" } 
        }
        
        expect(Resposta.count).to eq(1)
        expect(Resposta.first.conteudo).to eq("O professor domina o assunto!")
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to match(/Avaliação enviada com sucesso/)
      end
    end

    context "Sad Path" do
      it "falha ao tentar enviar uma resposta sem conteúdo (simulando erro de validação de banco)" do
        #para forçar um RecordInvalid,é só tentar salvar uma resposta sem a questão associada corretamente. Como o controller itera sobre as respostas, se passou um ID de questão inválido, falha.
        post responder_formulario_path(@formulario), params: { 
          respostas: { "" => "Resposta fantasma" } 
        }
        
        expect(Resposta.count).to eq(0)
        expect(response).to redirect_to(formulario_path(@formulario))
        expect(flash[:alert]).to include("Os seguintes campos são obrigatórios:")
      end
    end
  end
end