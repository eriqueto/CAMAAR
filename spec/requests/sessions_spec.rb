require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before(:each) do
    @pessoa = Pessoa.create!(
      usuario: '190000000', 
      email: 'arrascaeta@unb.br', 
      nome: 'Giorgian de Arrascacheira', 
      password: 'senha_segura', 
      password_confirmation: 'senha_segura'
    )
  end

  describe "POST /login" do
    context "Happy Path" do
      it "faz login com credenciais válidas e redireciona para a home" do
        post '/login', params: { login: 'arrascacheira@unb.br', password: 'senha_segura' }
        
        expect(session[:pessoa_id]).to eq(@pessoa.usuario)
        expect(response).to redirect_to(root_path)
      end
    end

    context "Sad Path" do
      it "rejeita o login com senha incorreta e renderiza a tela novamente" do
        post '/login', params: { login: 'arrascacheira@unb.br', password: 'senha_errada' }
        
        expect(session[:pessoa_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq("E-mail/Matrícula ou senha inválidos")
      end
    end
  end

  describe "DELETE /logout" do
    it "encerra a sessão e redireciona para a página de login" do
      # Força o login primeiro
      post '/login', params: { login: 'arrascacheira@unb.br', password: 'senha_segura' }
      
      delete '/logout'
      
      expect(session[:pessoa_id]).to be_nil
      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq("Logout realizado com sucesso.")
    end
  end
end